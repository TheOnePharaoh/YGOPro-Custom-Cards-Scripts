--ANTI-MATTER Being, Barrengly
function c1143289.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xaf75),aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c1143289.efilter)
	c:RegisterEffect(e1)
	--negate&banish
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_REMOVE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCountLimit(1)
	e2:SetCondition(c1143289.negcon)
	e2:SetCost(c1143289.negcost)
	e2:SetTarget(c1143289.negtg)
	e2:SetOperation(c1143289.negop)
	c:RegisterEffect(e2)
	--banish
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1143289,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetCondition(c1143289.condition)
	e3:SetTarget(c1143289.target)
	e3:SetOperation(c1143289.operation)
	c:RegisterEffect(e3)
	--Self Synchro
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1143289,1))
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TODECK)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetRange(LOCATION_REMOVED)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e4:SetCountLimit(1,1143289)
	e4:SetCondition(c1143289.syncon)
	e4:SetTarget(c1143289.syntg)
	e4:SetOperation(c1143289.synop)
	c:RegisterEffect(e4)
	if not c1143289.global_check then
		c1143289.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_EXTRA+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY,LOCATION_EXTRA+LOCATION_HAND+LOCATION_MZONE+LOCATION_OVERLAY)
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,1143289))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c1143289.efilter(e,re,rp,c)
	return e:GetHandlerPlayer()~=re:GetOwnerPlayer() and not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end
function c1143289.negcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:GetHandler()~=e:GetHandler()
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c1143289.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0xaf75) and not c:IsCode(1143289) and c:IsDestructable()
end
function c1143289.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1143289.costfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c1143289.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Destroy(g,REASON_COST)
end
function c1143289.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsAbleToRemove() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c1143289.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
	end
end
function c1143289.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bit.band(bc:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c1143289.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c1143289.operation(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.Remove(bc,POS_FACEUP,REASON_EFFECT)
	end
end
function c1143289.syncon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c1143289.filter1(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0xaf75) and c:IsType(TYPE_TUNER)
		and Duel.IsExistingTarget(c1143289.filter2,tp,LOCATION_REMOVED,0,1,nil,e,tp,c:GetLevel())
end
function c1143289.filter2(c,e,tp,lv)
	local clv=c:GetLevel()
	return clv>0 and c:IsFaceup() and c:IsSetCard(0xaf75) and not c:IsType(TYPE_TUNER)
		and Duel.IsExistingMatchingCard(c1143289.synfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp,lv+clv)
end
function c1143289.synfilter(c,e,tp,lv)
	return c:IsCode(1143289) and c:GetLevel()==lv and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1143289.syntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c1143289.filter1,tp,LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g1=Duel.SelectTarget(tp,c1143289.filter1,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectTarget(tp,c1143289.filter2,tp,LOCATION_REMOVED,0,1,1,nil,e,tp,g1:GetFirst():GetLevel())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g1,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_REMOVED)
end
function c1143289.synop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	if not tc1:IsRelateToEffect(e) or not tc2:IsRelateToEffect(e) then return end
	local sg=Duel.GetMatchingGroup(c1143289.synfilter,tp,LOCATION_REMOVED,0,nil,e,tp,tc1:GetLevel()+tc2:GetLevel())
	if sg:GetCount()==0 then return end
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT+REASON_RETURN)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ssg=sg:Select(tp,1,1,nil)
	Duel.SpecialSummon(ssg,0,tp,tp,false,false,POS_FACEUP_ATTACK)
end
