--Seafarer Undead Gunslinger Cecile
function c77777704.initial_effect(c)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsSetCard,0x669),1)
	c:EnableReviveLimit()
	--spell/trap to hand
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,7777770401)
	e1:SetCondition(c77777704.con)
	e1:SetTarget(c77777704.thtg)
	e1:SetOperation(c77777704.thop)
	c:RegisterEffect(e1)
	--Destroy 2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetDescription(aux.Stringid(77777704,1))
	e2:SetTarget(c77777704.destarget)
	e2:SetOperation(c77777704.desoperation)
	c:RegisterEffect(e2)
end


function c77777704.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end

function c77777704.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)and c:IsSetCard(0x669) and c:IsAbleToHand()
end
function c77777704.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c77777704.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c77777704.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c77777704.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c77777704.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end


function c77777704.dfilter(c,s)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsDestructable()
end
function c77777704.destarget(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_MZONE,2,nil)
		and Duel.IsExistingMatchingCard(c77777704.dfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler())end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c77777704.dfilter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c77777704.desoperation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_MZONE,2,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g2=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_MZONE,2,2,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g2,g2:GetCount(),0,0)
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if not g then return end
		local sg=g:Filter(Card.IsRelateToEffect,nil,e)
		if sg:GetCount()~=2 then return end
		Duel.Destroy(g,REASON_EFFECT)
	end
end
