--Sword Art Champion Luciel
function c20912311.initial_effect(c)
	--attach
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20912311,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e1:SetCountLimit(1,20912311)
	e1:SetTarget(c20912311.xyztg)
	e1:SetOperation(c20912311.xyzop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(20912311,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,20912311)
	e2:SetTarget(c20912311.thtg)
	e2:SetOperation(c20912311.tgop)
	c:RegisterEffect(e2)
	--lv change
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20912311,2))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,20912311)
	e3:SetCost(c20912311.cost)
	e3:SetTarget(c20912311.target)
	e3:SetOperation(c20912311.operation)
	c:RegisterEffect(e3)
end
function c20912311.xyzfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_XYZ)
end
function c20912311.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c20912311.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20912311.xyzfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c20912311.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c20912311.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
function c20912311.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xd0a2) and not c:IsCode(20912311) and c:IsAbleToHand()
end
function c20912311.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20912311.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c20912311.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c20912311.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c20912311.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c20912311.selfilter(c)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsRace(RACE_WARRIOR) and not c:IsType(TYPE_XYZ)
end
function c20912311.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c20912311.selfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20912311.selfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c20912311.selfilter,tp,LOCATION_MZONE,0,1,2,nil)
	local t={}
	local p=1
	local lv1=g:GetFirst():GetLevel()
	local lv2=0
	local tc2=g:GetNext()
	if tc2 then lv2=tc2:GetLevel() end
	for i=1,5 do
		if lv1~=i and lv2~=i then t[p]=i p=p+1 end
	end
	Duel.Hint(HINT_SELECTMSG,tp,567)
	local lv=Duel.AnnounceNumber(tp,table.unpack(t))
	e:SetLabel(lv)
end
function c20912311.lvfilter(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e)
end
function c20912311.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c20912311.lvfilter,nil,e)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c20912311.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c20912311.splimit(e,c)
	return c:GetRace()~=RACE_WARRIOR
end
