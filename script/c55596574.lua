--Predator Plant Mind Pitcher
function c55596574.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCodeFun(c,31218445,c55596574.ffilter,1,true,false)
	--counter1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(55596574,0))
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(c55596574.ctg)
	e1:SetOperation(c55596574.cop)
	c:RegisterEffect(e1)
		--counter2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(55596574,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetCondition(c55596574.ctcon)
	e2:SetOperation(c55596574.ctop)
	c:RegisterEffect(e2)
		--cannot attack announce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e3:SetTarget(c55596574.atktg)
	c:RegisterEffect(e3)
end

function c55596574.ffilter(c)
	return c:GetLevel()==3 and c:IsSetCard(0xf3)
end
function c55596574.ctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_MZONE,1,2,nil)
end
function c55596574.cop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
		if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
		tc:AddCounter(0x1041,1)
		tc=g:GetNext()
		end
       end
end
function c55596574.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
end
function c55596574.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetReasonCard()
	if tc:IsFaceup() and tc:IsRelateToBattle() then
		tc:AddCounter(0x1041,1)
	end
end
function c55596574.atktg(e,c)
	return c:GetCounter(0x1041)>0
end