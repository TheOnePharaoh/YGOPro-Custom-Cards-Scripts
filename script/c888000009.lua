--Evil HERO Wild Necromancer
function c888000009.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,86188410,89252153,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c888000009.splimit)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(888000009,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c888000009.condition)
	e2:SetTarget(c888000009.target)
	e2:SetOperation(c888000009.operation)
	c:RegisterEffect(e2)
end
c888000009.dark_calling=true
function c888000009.splimit(e,se,sp,st)
	return st==SUMMON_TYPE_FUSION+0x10
end
function c888000009.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c888000009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c888000009.spfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp) and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
end
function c888000009.operation(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,0,LOCATION_MZONE,nil)
	local dg=Duel.Destroy(sg,REASON_EFFECT)
	if dg~=0 then
		Duel.BreakEffect()
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>(dg-1) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,c888000009.spfilter,tp,0,LOCATION_GRAVE,dg,dg,nil,e,tp)
			if g:GetCount()>0 then
				if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)>0 then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
					e1:SetCode(EVENT_PHASE+PHASE_END)
					e1:SetCountLimit(1)
					e1:SetReset(RESET_PHASE+PHASE_END)
					e1:SetOperation(c888000009.desop)
					Duel.RegisterEffect(e1,tp)
					local e2=Effect.CreateEffect(e:GetHandler())
					e2:SetType(EFFECT_TYPE_FIELD)
					e2:SetRange(LOCATION_MZONE)
					e2:SetCode(EFFECT_CANNOT_SUMMON)
					e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
					e2:SetTargetRange(1,0)
					e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
					Duel.RegisterEffect(e2,tp)
					local e3=e2:Clone()
					e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
					Duel.RegisterEffect(e3,tp)
					local e4=e2:Clone()
					e4:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
					Duel.RegisterEffect(e4,tp)
				end
			end
		end
	end
end
function c888000009.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,0,nil)
	Duel.Destroy(sg,REASON_EFFECT)
end
