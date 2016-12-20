--Aetherial Girl Dracona
function c66666622.initial_effect(c)
    --pendulum summon
    aux.EnablePendulumAttribute(c)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetDescription(aux.Stringid(66666622,1))
	e2:SetRange(LOCATION_PZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c66666622.atktg1)
	e2:SetOperation(c66666622.atkop1)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_TO_DECK)
	e3:SetRange(LOCATION_PZONE)
	e3:SetDescription(aux.Stringid(66666622,2))
	e3:SetCountLimit(1)
	e3:SetCondition(c66666622.thcon)
	e3:SetTarget(c66666622.thtg)
	e3:SetOperation(c66666622.thop)
	c:RegisterEffect(e3)
	--lv change
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(66666622,3))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetCountLimit(1)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTarget(c66666622.tg)
	e4:SetOperation(c66666622.op)
	c:RegisterEffect(e4)
	--searchSpell
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(66666622,4))
	e5:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c66666622.cost)
	e5:SetCountLimit(1,66666622)
	e5:SetTarget(c66666622.target)
	e5:SetOperation(c66666622.operation)
	c:RegisterEffect(e5)
	--cannot negate summon
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e6)
	--splimit
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_PZONE)
	e7:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(1,0)
	e7:SetTarget(c66666622.splimit)
	c:RegisterEffect(e7)
	
end
function c66666622.splimit(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsRace(RACE_SPELLCASTER) and bit.band(sumtype,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c66666622.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x144)
end
function c66666622.atktg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c66666622.filter1(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c66666622.filter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c66666622.filter1,tp,LOCATION_MZONE,0,1,1,nil)
end
function c66666622.atkop1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(800)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end

function c66666622.thfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_EXTRA) and c:IsSetCard(0x144)
		and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c66666622.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c66666622.thfilter,1,nil,tp)
end
function c66666622.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c66666622.thfilter,nil,tp)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c66666622.thop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local rg=g:Select(tp,1,1,nil)
	if rg:GetCount()>0 then
		Duel.SendtoHand(rg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,rg)
	end
end

function c66666622.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local t={}
	local i=1
	local p=1
	local lv=e:GetHandler():GetLevel()
	for i=1,8 do 
		if lv~=i then t[p]=i p=p+1 end
	end
	t[p]=nil
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(66666622,3))
	e:SetLabel(Duel.AnnounceNumber(tp,table.unpack(t)))
end
function c66666622.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(e:GetLabel())
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end

function c66666622.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c66666622.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c66666622.filter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c66666622.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c66666622.filter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c66666622.filter2(c)
	return c:IsSetCard(0x144) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end