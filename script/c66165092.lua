--Nature's Supporting
function c66165092.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c66165092.target)
	e1:SetOperation(c66165092.activate)
	c:RegisterEffect(e1)
	--negate&summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DRAW+CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,66165092)
	e2:SetCondition(c66165092.negcon)
	e2:SetCost(c66165092.negcost)
	e2:SetTarget(c66165092.negstg)
	e2:SetOperation(c66165092.negop)
	c:RegisterEffect(e2)
end
function c66165092.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xea010) and c:IsAbleToGrave()
end
function c66165092.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66165092.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c66165092.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c66165092.tgfilter,tp,LOCATION_DECK,0,1,2,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c66165092.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(1-tp) and Duel.GetAttackTarget()==nil
end
function c66165092.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c66165092.negstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c66165092.negop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() and Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		if tc:IsType(TYPE_MONSTER) and tc:IsAttribute(ATTRIBUTE_EARTH) and tc:IsSummonable(true,nil) 
			and Duel.SelectYesNo(tp,aux.Stringid(66165092,0)) then
			Duel.Summon(tp,tc,true,nil)
		end
	end
end