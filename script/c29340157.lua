--Vocaloid Rana
function c29340157.initial_effect(c)
	--nontuner
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e1)
	--summon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(29340157,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetTarget(c29340157.sptg)
	e2:SetOperation(c29340157.spop)
	c:RegisterEffect(e2)
	--draw and deck destruct
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(29340157,1))
	e3:SetCategory(CATEGORY_DRAW+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1,29340157)
	e3:SetCondition(aux.exccon)
	e3:SetCost(c29340157.drcost)
	e3:SetTarget(c29340157.drtg)
	e3:SetOperation(c29340157.drop)
	c:RegisterEffect(e3)
end
function c29340157.spfilter(c,e,tp)
	return c:IsSetCard(0x0dac405) and c:IsLevelBelow(4) and not c:IsCode(29340157) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c29340157.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c29340157.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c29340157.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c29340157.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c29340157.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c29340157.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) and Duel.IsPlayerCanDiscardDeck(tp,2)
		and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=4 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(2)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,2)
end
function c29340157.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.DiscardDeck(tp,2,REASON_EFFECT)
end
