--God's Relic Sanctuary
function c55438817.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c55438817.target)
	e1:SetOperation(c55438817.activate)
	c:RegisterEffect(e1)
	--Heal
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(55438817,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c55438817.reccon)
	e2:SetTarget(c55438817.rectg)
	e2:SetOperation(c55438817.recop)
	c:RegisterEffect(e2)
	--Fusion Summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(55438817,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e1:SetCountLimit(1,55438817)
	e3:SetCost(c55438817.fuscost)
	e3:SetTarget(c55438817.fustg)
	e3:SetOperation(c55438817.fusop)
	c:RegisterEffect(e3)
end
function c55438817.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd70) and c:IsAbleToGrave()
end
function c55438817.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c55438817.tgfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,2,tp,LOCATION_DECK)
end
function c55438817.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c55438817.tgfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local sg=g:Select(tp,2,2,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
end
function c55438817.recfilter(c)
	return not c:IsType(TYPE_TOKEN)
end
function c55438817.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c55438817.recfilter,1,nil)
end
function c55438817.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	local ct=eg:FilterCount(c55438817.recfilter,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*300)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,0,0,tp,ct*300)
end
function c55438817.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Recover(p,d,REASON_EFFECT)
	end
end
function c55438817.fuscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c55438817.filter0(c)
	return c:IsFaceup() and c:IsCanBeFusionMaterial()
end
function c55438817.filter1(c,e)
	return c:IsFaceup() and c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c55438817.filter2(c,e,tp,m)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0xd70) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(m)
end
function c55438817.fustg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return false end
		local mg=Duel.GetMatchingGroup(c55438817.filter0,tp,LOCATION_REMOVED,0,nil)
		return Duel.IsExistingMatchingCard(c55438817.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c55438817.fusop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(c55438817.filter1,tp,LOCATION_REMOVED,0,nil,e)
	local sg=Duel.GetMatchingGroup(c55438817.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local mat=Duel.SelectFusionMaterial(tp,tc,mg)
		tc:SetMaterial(mat)
		Duel.SendtoGrave(mat,nil,2,REASON_EFFECT+REASON_RETURN+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc, SUMMON_TYPE_FUSION, tp, tp, false, false, POS_FACEUP)
		tc:CompleteProcedure()
	end
end