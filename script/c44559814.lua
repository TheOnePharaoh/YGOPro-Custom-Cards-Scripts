--Hou Yi, Descendant of the Nirvana
function c44559814.initial_effect(c)
	c:SetUniqueOnField(1,0,44559814)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c44559814.spcon1)
	e1:SetOperation(c44559814.spop1)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetTarget(c44559814.eqtg)
	e2:SetOperation(c44559814.eqop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetTarget(c44559814.desreptg)
	e5:SetOperation(c44559814.desrepop)
	e5:SetLabelObject(e2)
	c:RegisterEffect(e5)
	--special summon2
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetCode(EVENT_BATTLE_DESTROYING)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCondition(c44559814.spcon2)
	e6:SetTarget(c44559814.sptg)
	e6:SetOperation(c44559814.spop2)
	c:RegisterEffect(e6)
end
function c44559814.rfilter(c)
	return c:IsSetCard(0x2016)
end
function c44559814.spcon1(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(c:GetControler(),c44559814.rfilter,1,nil)
end
function c44559814.spop1(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectReleaseGroup(c:GetControler(),c44559814.rfilter,1,1,nil)
	Duel.Release(g,REASON_COST)
end
function c44559814.eqfilter(c)
	return c:IsFaceup() and c:IsAbleToChangeControler()
end
function c44559814.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c44559814.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c44559814.eqfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c44559814.eqfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c44559814.eqlimit(e,c)
	return e:GetOwner()==c
end
function c44559814.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			if not Duel.Equip(tp,tc,c,false) then return end
			--Add Equip limit
			tc:RegisterFlagEffect(44559814,RESET_EVENT+0x1fe0000,0,0)
			e:SetLabelObject(tc)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(c44559814.eqlimit)
			tc:RegisterEffect(e1)
		else Duel.SendtoGrave(tc,REASON_EFFECT) end
	end
end
function c44559814.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=e:GetLabelObject():GetLabelObject()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and ec and ec:IsHasCardTarget(c)
		and not ec:IsStatus(STATUS_DESTROY_CONFIRMED) and ec:GetFlagEffect(44559814)~=0 end
	return Duel.SelectYesNo(tp,aux.Stringid(44559814,0))
end
function c44559814.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetLabelObject():GetLabelObject(),REASON_EFFECT+REASON_REPLACE)
end
function c44559814.spcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if not c:IsRelateToBattle() or c:IsFacedown() then return false end
	return bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c44559814.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local bc=e:GetHandler():GetBattleTarget()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and bc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetTargetCard(bc)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,bc,1,0,LOCATION_GRAVE)
end
function c44559814.spop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
