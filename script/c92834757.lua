--Black Rose Dragon/Assault Mode
function c92834757.initial_effect(c)
	c:EnableReviveLimit()
	--Cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
		--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(73580471,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c92834757.destg)
	e2:SetOperation(c92834757.desop)
	c:RegisterEffect(e2)
		--pos
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(73580471,1))
	e3:SetCategory(CATEGORY_POSITION+CATEGORY_ATKCHANGE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c92834757.poscost)
	e3:SetTarget(c92834757.postg)
	e3:SetOperation(c92834757.posop)
	c:RegisterEffect(e3)
		--pierce
	local me2=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e4)
	--Special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(35952884,1))
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_LEAVE_FIELD)
	e5:SetCondition(c92834757.spcon)
	e5:SetTarget(c92834757.sptg)
	e5:SetOperation(c92834757.spop)
	c:RegisterEffect(e5)
end
function c92834757.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c92834757.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
function c92834757.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c92834757.poscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c92834757.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c92834757.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c92834757.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingMatchingGroup(nil,tp,0,LOCATION_MZONE,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end
function c92834757.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
	if not tc or not tc:IsRelateToEffect(e) then return end
	if (not tc:IsAttackPos()) then Duel.ChangePosition(tc,POS_FACEUP_ATTACK) 
	else Duel.ChangePosition(tc,POS_FACEUP_DEFENSE) end
	
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetValue(0)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e2:SetValue(0)
	tc:RegisterEffect(e2)
	tc=g:GetNext()
	end
end


function c92834757.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c92834757.spfilter(c,e,tp)
	return c:IsCode(73580471) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c92834757.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c92834757.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c92834757.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c92834757.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c92834757.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
