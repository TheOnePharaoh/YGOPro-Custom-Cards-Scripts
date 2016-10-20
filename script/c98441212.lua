--Shaddoll Narwal
function c98441212.initial_effect(c)
	--flip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(98441212,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_FLIP+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,98441212)
	e1:SetTarget(c98441212.target)
	e1:SetOperation(c98441212.operation)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98441212,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,98441212)
	e2:SetCost(c98441212.drcost)
	e2:SetTarget(c98441212.drtg)
	e2:SetOperation(c98441212.drop)
	c:RegisterEffect(e2)
end
function c98441212.spfilter(c,e,tp)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x9d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98441212.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98441212.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c98441212.desfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c98441212.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c98441212.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 and Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local dg=Duel.SelectMatchingCard(tp,c98441212.desfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c98441212.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c98441212.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c98441212.drop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	local tc=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,tc)
	if tc:IsSetCard(0x9d) and Duel.IsPlayerCanDraw(tp,1) then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	end
end