--Searing Rage
function c42599683.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,42599683)
	e1:SetTarget(c42599683.target)
	e1:SetOperation(c42599683.activate)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(42599683,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,42599683)
	e2:SetCost(c42599683.spcost)
	e2:SetTarget(c42599683.sptarget)
	e2:SetOperation(c42599683.spoperation)
	c:RegisterEffect(e2)
end
function c42599683.limfil(c)
	return c:IsFaceup() and c:IsCode(42599677)
end
function c42599683.chlimit(e,ep,tp)
	return tp==ep
end
function c42599683.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,1000)
	if Duel.IsExistingMatchingCard(c42599683.limfil,tp,LOCATION_MZONE,0,1,nil) then
		Duel.SetChainLimit(c42599683.chlimit)
	end
end
function c42599683.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.Damage(tp,1000,REASON_EFFECT)
end
function c42599683.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c42599683.confilter(c)
	return c:IsType(TYPE_NORMAL) or c:IsType(TYPE_DUAL)
end
function c42599683.spefilter(c,e,tp)
	return c42599683.confilter(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c42599683.sptarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c42599683.spefilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
	if Duel.IsExistingMatchingCard(c42599683.limfil,tp,LOCATION_MZONE,0,1,nil) then
		Duel.SetChainLimit(c42599683.chlimit)
	end
end
function c42599683.spoperation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c42599683.spefilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
