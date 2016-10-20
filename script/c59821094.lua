--Triple Tag
function c59821094.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCountLimit(1,59821094)
	e1:SetCondition(c59821094.condition)
	e1:SetTarget(c59821094.target)
	e1:SetOperation(c59821094.activate)
	c:RegisterEffect(e1)
	if not c59821094.global_check then
		c59821094.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(c59821094.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c59821094.checkop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local t=Duel.GetAttackTarget()
	if a and a:IsAttackPos() and a:IsLevelBelow(4) and a:IsType(TYPE_PENDULUM) and a:IsSetCard(0xa1a2) and a:IsStatus(STATUS_BATTLE_DESTROYED) then
		a:RegisterFlagEffect(59821094,RESET_PHASE+PHASE_DAMAGE,0,1)
	end
	if t and t:IsAttackPos() and t:IsLevelBelow(4) and t:IsType(TYPE_PENDULUM) and t:IsSetCard(0xa1a2) and t:IsStatus(STATUS_BATTLE_DESTROYED) then
		t:RegisterFlagEffect(59821094,RESET_PHASE+PHASE_DAMAGE,0,1)
	end
end
function c59821094.filter(c,e,tp)
	if c:GetFlagEffect(59821094)~=0 and c:GetPreviousControler()==tp then
		e:SetLabel(c:GetCode())
		return true
	else return false end
end
function c59821094.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c59821094.filter,1,nil,e,tp)
end
function c59821094.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c59821094.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c59821094.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp,e:GetLabel()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function c59821094.activate(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>2 then ft=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c59821094.spfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,ft,nil,e,tp,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
