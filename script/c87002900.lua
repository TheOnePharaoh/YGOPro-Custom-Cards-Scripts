--May-Raias Infected
function c87002900.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87002900,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c87002900.spcon)
	e1:SetCost(c87002900.spcost)
	e1:SetTarget(c87002900.sptg)
	e1:SetOperation(c87002900.spop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(87002900,1))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c87002900.sccon)
	e2:SetOperation(c87002900.scop)
	c:RegisterEffect(e2)
	--take control
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(87002900,2))
	e3:SetCategory(CATEGORY_CONTROL)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCondition(c87002900.reccon)
	e3:SetTarget(c87002900.rectg)
	e3:SetOperation(c87002900.recop)
	c:RegisterEffect(e3)
end
function c87002900.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function c87002900.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c87002900.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0xe291ca) and not c:IsCode(87002900) and c:IsCanBeSpecialSummoned(e,200,tp,false,false)
end
function c87002900.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c87002900.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c87002900.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c87002900.filter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,200,tp,tp,false,false,POS_FACEUP)
		tc:RegisterFlagEffect(tc:GetOriginalCode(),RESET_EVENT+0x1ff0000,0,0)
	end
end
function c87002900.sccon(e,tp,eg,ep,ev,re,r,rp)
	local st=e:GetHandler():GetSummonType()
	return st>=(SUMMON_TYPE_SPECIAL+200) and st<(SUMMON_TYPE_SPECIAL+250)
end
function c87002900.atkfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xe291ca)
end
function c87002900.scop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c87002900.atkfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(500)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c87002900.reccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function c87002900.recfilter(c)
	return c:IsControlerCanBeChanged() and c:IsFaceup()
end
function c87002900.rectg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c87002900.recfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c87002900.recfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,c87002900.recfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function c87002900.recop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not Duel.GetControl(tc,tp,PHASE_END,1) then
		if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
