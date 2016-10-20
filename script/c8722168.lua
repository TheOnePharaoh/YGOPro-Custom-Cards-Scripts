--Kryos' Ambush Squad
function c8722168.initial_effect(c)
	--fustion material
	aux.AddFusionProcFunRep(c,aux.FilterBoolFunction(Card.IsSetCard,0xb1b32),3,true)
	c:EnableReviveLimit()
	--cannot spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(c8722168.splimit)
	c:RegisterEffect(e1)
	--protect
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(8722168,0))
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c8722168.target)
	e2:SetOperation(c8722168.operation)
	c:RegisterEffect(e2)
	--tohand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(8722168,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetTarget(c8722168.thtg)
	e3:SetOperation(c8722168.thop)
	c:RegisterEffect(e3)
end
function c8722168.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c8722168.efilter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON)
end
function c8722168.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsOnField() and c8722168.efilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c8722168.efilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c8722168.efilter,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function c8722168.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCountLimit(1)
		e1:SetValue(c8722168.valcon)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c8722168.valcon(e,re,r,rp)
	return bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0
end

function c8722168.thfilter(c)
	return c:IsSetCard(0xb1b32) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c8722168.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c8722168.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c8722168.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c8722168.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c8722168.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
