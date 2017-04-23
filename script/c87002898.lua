--May-Raias Vestas
function c87002898.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(87002898,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,87002898)
	e1:SetTarget(c87002898.spectg)
	e1:SetOperation(c87002898.specop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e4)
	--equip
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(87002898,1))
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(c87002898.eqtg)
	e5:SetOperation(c87002898.eqop)
	c:RegisterEffect(e5)
	--unequip
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(87002898,2))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_IGNITION)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCondition(aux.IsUnionState)
	e6:SetTarget(c87002898.sptg)
	e6:SetOperation(c87002898.spop)
	c:RegisterEffect(e6)
	--Atk up
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_EQUIP)
	e7:SetCode(EFFECT_UPDATE_ATTACK)
	e7:SetValue(500)
	e7:SetCondition(aux.IsUnionState)
	c:RegisterEffect(e7)
	--Def up
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_EQUIP)
	e8:SetCode(EFFECT_UPDATE_DEFENSE)
	e8:SetValue(500)
	e8:SetCondition(aux.IsUnionState)
	c:RegisterEffect(e8)
	--destroy sub
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_EQUIP)
	e9:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e9:SetCode(EFFECT_DESTROY_SUBSTITUTE)
	e9:SetCondition(aux.IsUnionState)
	e9:SetValue(1)
	c:RegisterEffect(e9)
	--eqlimit
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_EQUIP_LIMIT)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetValue(c87002898.eqlimit)
	c:RegisterEffect(e10)
end
c87002898.old_union=true
function c87002898.spefilter(c,e,tp)
	return c:IsCode(87002899) and c:IsCanBeSpecialSummoned(e,200,tp,false,false)
end
function c87002898.spectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c87002898.spefilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c87002898.specop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c87002898.spefilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,200,tp,tp,false,false,POS_FACEUP)
	end
end
function c87002898.eqlimit(e,c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xe291ca)
end
function c87002898.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xe291ca) and c:GetUnionCount()==0
end
function c87002898.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c87002898.filter(chkc) and chkc~=e:GetHandler() end
	if chk==0 then return e:GetHandler():GetFlagEffect(87002898)==0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c87002898.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c87002898.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
	e:GetHandler():RegisterFlagEffect(87002898,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c87002898.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	if not tc:IsRelateToEffect(e) or not c87002898.filter(tc) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	if not Duel.Equip(tp,c,tc,false) then return end
	aux.SetUnionState(c)
end
function c87002898.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(87002898)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	e:GetHandler():RegisterFlagEffect(87002898,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c87002898.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_ATTACK)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
