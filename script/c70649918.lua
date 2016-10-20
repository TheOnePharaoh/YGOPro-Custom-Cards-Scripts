--Destructive Roar
function c70649918.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c70649918.condition)
	e1:SetTarget(c70649918.target)
	e1:SetOperation(c70649918.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1,70649918)
	e2:SetCondition(aux.exccon)
	e2:SetCost(c70649918.dracost)
	e2:SetTarget(c70649918.dratg)
	e2:SetOperation(c70649918.draop)
	c:RegisterEffect(e2)
end
function c70649918.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c70649918.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c70649918.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c70649918.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) end
	local sg=Duel.GetMatchingGroup(c70649918.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c70649918.activate(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c70649918.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	Duel.Destroy(sg,REASON_EFFECT)
end
function c70649918.dracost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c70649918.dratg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c70649918.draop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local sg=tg:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(sg,REASON_EFFECT)
	sg=Duel.GetOperatedGroup()
	local d1=0
	local d2=0
	local tc=sg:GetFirst()
	while tc do
		if tc then
			if tc:GetPreviousControler()==0 then d1=d1+1
			else d2=d2+1 end
		end
		tc=sg:GetNext()
	end
	if d1>0 and Duel.SelectYesNo(0,aux.Stringid(70649918,0)) then Duel.Draw(0,d1,REASON_EFFECT) end
	if d2>0 and Duel.SelectYesNo(1,aux.Stringid(70649918,0)) then Duel.Draw(1,d2,REASON_EFFECT) end
end
