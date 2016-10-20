--Vocaloid Otomachi Una
function c84435257.initial_effect(c)
	--material
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(84435257,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_GRAVE+LOCATION_HAND)
	e1:SetCountLimit(1,84435257)
	e1:SetTarget(c84435257.xyztg)
	e1:SetOperation(c84435257.xyzop)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(84435257,1))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,84435257)
	e2:SetTarget(c84435257.thtg)
	e2:SetOperation(c84435257.tgop)
	c:RegisterEffect(e2)
	--nontuner
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_NONTUNER)
	c:RegisterEffect(e3)
	--lv change
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(84435257,2))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCountLimit(1,84435257)
	e4:SetCost(c84435257.cost)
	e4:SetTarget(c84435257.target)
	e4:SetOperation(c84435257.operation)
	c:RegisterEffect(e4)
end
function c84435257.xyzfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac404) and c:IsType(TYPE_XYZ)
end
function c84435257.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c84435257.xyzfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c84435257.xyzfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c84435257.xyzfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c84435257.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
function c84435257.thfilter(c)
	return c:IsSetCard(0x0dac405) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c84435257.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c84435257.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c84435257.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c84435257.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c84435257.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c84435257.selfilter(c)
	return c:IsFaceup() and c:GetLevel()>0 and c:IsSetCard(0x0dac405)
end
function c84435257.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c84435257.selfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c84435257.selfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c84435257.selfilter,tp,LOCATION_MZONE,0,1,2,nil)
	local t={}
	local p=1
	local lv1=g:GetFirst():GetLevel()
	local lv2=0
	local tc2=g:GetNext()
	if tc2 then lv2=tc2:GetLevel() end
	for i=1,10 do
		if lv1~=i and lv2~=i then t[p]=i p=p+1 end
	end
	Duel.Hint(HINT_SELECTMSG,tp,567)
	local lv=Duel.AnnounceNumber(tp,table.unpack(t))
	e:SetLabel(lv)
end
function c84435257.lvfilter(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e)
end
function c84435257.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c84435257.lvfilter,nil,e)
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
	e1:SetTarget(c84435257.splimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c84435257.splimit(e,c)
	return c:GetRace()~=RACE_MACHINE
end

