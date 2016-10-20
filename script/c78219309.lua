--Colossal Warrior - Psychic
function c78219309.initial_effect(c)
	--send replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c78219309.repcon)
	e1:SetOperation(c78219309.repop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(78219309,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c78219309.target)
	e2:SetOperation(c78219309.operation)
	c:RegisterEffect(e2)
	--atklimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(c78219309.atklimtg)
	c:RegisterEffect(e3)
end
function c78219309.repcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c78219309.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	Duel.RaiseEvent(c,EVENT_CUSTOM+78219309,e,0,tp,0,0)
end
function c78219309.spfilter(c,e,sp)
	return c:IsFaceup() and c:IsSetCard(0x7ad30) and not c:IsType(TYPE_PENDULUM) and c:IsCanBeSpecialSummoned(e,0,sp,true,false)
end
function c78219309.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78219309.spfilter,tp,LOCATION_SZONE,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local gct=Duel.GetMatchingGroupCount(c78219309.spfilter,tp,LOCATION_SZONE,0,nil,e,tp)
	if ct>gct then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,gct,tp,LOCATION_SZONE)
	else
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,ct,tp,LOCATION_SZONE)
	end
end
function c78219309.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct==0 then return end
	local g=Duel.GetMatchingGroup(c78219309.spfilter,tp,LOCATION_SZONE,0,nil,e,tp)
	local gc=g:GetCount()
	if gc==0 then return end
	if gc<=ct then
		Duel.SpecialSummon(g,0,tp,tp,true,false,POS_FACEUP)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,ct,ct,nil)
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	end
end
function c78219309.atklimtg(e,c)
	return c:IsPosition(POS_FACEUP_ATTACK) and c:GetAttack()==0
end
