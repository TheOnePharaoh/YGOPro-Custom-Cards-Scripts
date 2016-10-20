--Mail Skull Carole the Queen
function c160008954.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,500314712,160003343,false,false)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c160008954.splimit)
	c:RegisterEffect(e1)
	--attack all
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ATTACK_ALL)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(160008954,0))
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c160008954.discon)
	e3:SetTarget(c160008954.distg)
	e3:SetOperation(c160008954.disop)
	c:RegisterEffect(e3)
	--Special Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(160008954,1))
	e4:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c160008954.sumcon)
	e4:SetTarget(c160008954.sumtg)
	e4:SetOperation(c160008954.sumop)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_REMOVE)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_TO_DECK)
	c:RegisterEffect(e6)
end
function c160008954.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and se:GetHandler():IsSetCard(0xc81)
end
function c160008954.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP)or re:IsActiveType(TYPE_MONSTER)  and Duel.IsChainNegatable(ev)
end
function c160008954.filter(c)
	return c:IsSetCard(0xc81) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function c160008954.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c160008954.filter,tp,LOCATION_HAND,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)==1 end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c160008954.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
	Duel.DiscardHand(tp,c160008954.filter,1,1,REASON_EFFECT+REASON_DISCARD,nil)
end
function c160008954.sumcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c160008954.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,0,0)
end
function c160008954.sumop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,67568955,0,0x4011,0,0,12,RACE_FIEND,ATTRIBUTE_DARK) then return end
	for i=1,2 do
		local token=Duel.CreateToken(tp,160008954+i)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UNRELEASABLE_SUM)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(1)
		token:RegisterEffect(e1,true)
	end
	Duel.SpecialSummonComplete()
end
