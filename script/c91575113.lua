--B.M.I. Engine Reservation
function c91575113.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e1:SetCondition(c91575113.condition)
	e1:SetTarget(c91575113.target)
	e1:SetOperation(c91575113.activate)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(91575113,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c91575113.drcon)
	e2:SetTarget(c91575113.drtg)
	e2:SetOperation(c91575113.drop)
	c:RegisterEffect(e2)
end
function c91575113.cefilter(c,tp)
	return c:IsPreviousLocation(LOCATION_MZONE) and c:GetPreviousControler()==tp
		and c:GetControler()==tp and c:IsReason(REASON_DESTROY) and c:IsRace(RACE_MACHINE)
		and (c:IsReason(REASON_EFFECT) or (c:IsReason(REASON_BATTLE) and Duel.GetAttacker():IsControler(1-tp)))
end
function c91575113.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c91575113.cefilter,1,nil,tp)
end
function c91575113.limfil(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsSetCard(0x0dac402)
end
function c91575113.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
	if Duel.IsExistingMatchingCard(c91575113.limfil,tp,LOCATION_MZONE,0,1,nil) then
		Duel.SetChainLimit(c91575113.chlimit)
	end
end
function c91575113.chlimit(e,ep,tp)
	return tp==ep
end
function c91575113.filter(c,lp)
	return c:IsType(TYPE_TUNER) and c:IsSetCard(0x0dac405) and c:IsAttackBelow(lp) and c:IsAbleToHand()
end
function c91575113.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_DECK,0)
	if g:GetCount()<1 then return end
	Duel.ConfirmCards(tp,g)
	local lp=Duel.GetLP(tp)
	if g:IsExists(c91575113.filter,1,nil,lp) and Duel.SelectYesNo(tp,aux.Stringid(91575113,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,c91575113.filter,1,1,nil,lp)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
	end
	Duel.ShuffleDeck(tp)
end
function c91575113.drcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_DESTROY)~=0
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
		and e:GetHandler():IsPreviousPosition(POS_FACEDOWN)
end
function c91575113.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) end
	local ht=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(5-ht)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,5-ht)
end
function c91575113.drop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ht=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	if ht<5 then
		Duel.Draw(p,5-ht,REASON_EFFECT)
	end
end
