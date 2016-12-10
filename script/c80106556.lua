--Negative Filament
function c80106556.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(80106556,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c80106556.condition1)
	e2:SetTarget(c80106556.target)
	e2:SetOperation(c80106556.operation)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(80106556,2))
	e3:SetCategory(CATEGORY_HANDES+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c80106556.thcon)
	e3:SetTarget(c80106556.thtg)
	e3:SetOperation(c80106556.thop)
	c:RegisterEffect(e3)
	--hand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(80106556,3))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,80106556)
	e4:SetCondition(c80106556.hdcon)
	e4:SetTarget(c80106556.hdtg)
	e4:SetOperation(c80106556.hdop)
	c:RegisterEffect(e4)
	--draw2
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(80106556,1))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c80106556.condition2)
	e5:SetTarget(c80106556.target)
	e5:SetOperation(c80106556.operation)
	c:RegisterEffect(e5)
end
function c80106556.leavefilter1(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsControler(tp) and c:IsReason(REASON_DISCARD+REASON_EFFECT)
end
function c80106556.condition1(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp and eg:IsExists(c80106556.leavefilter1,1,nil,tp)
end
function c80106556.leavefilter2(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND) and c:IsControler(tp) and c:IsReason(REASON_COST+REASON_DISCARD+REASON_EFFECT)
end
function c80106556.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c80106556.leavefilter2,1,nil,tp)
end
function c80106556.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c80106556.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c80106556.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsSetCard(0xca00) and not c:IsCode(80106556) and c:IsAbleToHand()
end
function c80106556.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)<3
end
function c80106556.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local hd=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		if e:GetHandler():IsLocation(LOCATION_HAND) then hd=hd-1 end
		return hd>0 and Duel.IsExistingMatchingCard(c80106556.thfilter,tp,LOCATION_DECK,0,hd,nil)
	end
	local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	local tg=Duel.GetMatchingGroup(c80106556.thfilter,tp,LOCATION_DECK,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,sg,sg:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,sg:GetCount(),0,0)
end
function c80106556.thop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	Duel.SendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	local ct=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE):GetCount()
	local tg=Duel.GetMatchingGroup(c80106556.thfilter,tp,LOCATION_DECK,0,nil)
	if ct>0 and tg:GetCount()>=ct then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sel=tg:Select(tp,ct,ct,nil)
		Duel.SendtoHand(sel,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sel)
	end
end
function c80106556.hdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_EFFECT) and e:GetHandler():IsPreviousLocation(LOCATION_HAND) and not e:GetHandler():IsReason(REASON_RETURN)
end
function c80106556.hdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local h=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
		return h<3 and Duel.IsPlayerCanDraw(tp,3-h)
	end
	local h=Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(3-h)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,3-h)
end
function c80106556.hdop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local h=Duel.GetFieldGroupCount(p,LOCATION_HAND,0)
	if h>=3 then return end
	Duel.Draw(p,3-h,REASON_EFFECT)
end
