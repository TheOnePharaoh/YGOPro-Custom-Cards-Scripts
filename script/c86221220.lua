--Vocaloid Hatsune Miku/Assault Mode
function c86221220.initial_effect(c)
	c:EnableReviveLimit()
	--Cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c86221220.efilter)
	c:RegisterEffect(e2)
	--cannot attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetCondition(c86221220.limcon)
	c:RegisterEffect(e3)
	--remove
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(86221220,0))
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c86221220.remtg)
	e4:SetOperation(c86221220.remop)
	c:RegisterEffect(e4)
	--Special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(86221220,1))
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(c86221220.spcon)
	e5:SetTarget(c86221220.sptg)
	e5:SetOperation(c86221220.spop)
	c:RegisterEffect(e5)
end
function c86221220.efilter(e,te)
	return te:IsActiveType(TYPE_MONSTER) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c86221220.limcon(e)
	return not Duel.IsExistingMatchingCard(nil,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function c86221220.tfilter(c,atk)
	return c:IsFaceup() and not c:IsRace(RACE_MACHINE) and c:GetAttack()<=atk and c:IsAbleToRemove()
end
function c86221220.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c86221220.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,c:GetAttack())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
	Duel.SetChainLimit(aux.FALSE)
end
function c86221220.remop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c86221220.tfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c,c:GetAttack())
	local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	if ct>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*300)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		c:RegisterEffect(e1)
	end
end
function c86221220.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c86221220.spfilter(c,e,tp)
	return c:IsCode(58431891) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c86221220.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c86221220.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c86221220.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c86221220.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c86221220.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
