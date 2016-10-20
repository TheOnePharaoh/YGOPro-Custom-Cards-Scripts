--A Journey to the West
function c44559803.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c44559803.target)
	e1:SetOperation(c44559803.activate)
	c:RegisterEffect(e1)
	--shuffle
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(44559803,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(aux.exccon)
	e2:SetCountLimit(1,44559803)
	e2:SetCost(c44559803.shufcost)
	e2:SetTarget(c44559803.shuftg)
	e2:SetOperation(c44559803.shufop)
	c:RegisterEffect(e2)
end
function c44559803.tgfilter(c,tp)
	return c:IsSetCard(0x2016) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
		and Duel.IsExistingMatchingCard(c44559803.thfilter,tp,LOCATION_DECK,0,1,nil,c:GetCode())
end
function c44559803.thfilter(c,code)
	return c:IsSetCard(0x2016) and c:IsType(TYPE_MONSTER) and not c:IsCode(code) and c:IsAbleToHand()
end
function c44559803.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44559803.tgfilter,tp,LOCATION_MZONE,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_MZONE)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c44559803.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c44559803.tgfilter,tp,LOCATION_MZONE,0,1,1,nil,tp)
	local tc=g:GetFirst()
	if tc and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)~=0 and tc:IsLocation(LOCATION_DECK) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,c44559803.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		if sg:GetCount()>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
function c44559803.shufcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToDeckAsCost() end
	Duel.SendtoDeck(e:GetHandler(),nil,2,REASON_COST)
end
function c44559803.shuftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>4 end
end
function c44559803.shufop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SortDecktop(tp,tp,5)
end
