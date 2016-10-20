--Arcana Force XVII The Star
function c123210.initial_effect(c)
	--coin
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(123210,0))
	e1:SetCategory(CATEGORY_COIN)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c123210.cointg)
	e1:SetOperation(c123210.coinop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	-- LP increase
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_REPEAT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c123210.reccon)
	e4:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e4:SetTarget(c123210.rectg)
	e4:SetOperation(c123210.recop)
	c:RegisterEffect(e4)
end
function c123210.reccon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c123210.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c123210.recop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c123210.cointg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_COIN,nil,0,tp,1)
end
function c123210.coinop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local res=0
	if c:IsHasEffect(73206827) then
		res=1-Duel.SelectOption(tp,60,61)
	else res=Duel.TossCoin(tp,1) end
	c123210.arcanareg(c,res)
end
function c123210.arcanareg(c,coin)
	--coin effect
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(123210,1))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_REPEAT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c123210.ctcon)
	e1:SetTarget(c123210.cttg)
	e1:SetOperation(c123210.ctop)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(123210,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_REPEAT)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c123210.ctcon2)
	e2:SetTarget(c123210.cttg2)
	e2:SetOperation(c123210.ctop2)
	e2:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e2)
	c:RegisterFlagEffect(36690018,RESET_EVENT+0x1ff0000,EFFECT_FLAG_CLIENT_HINT,1,coin,63-coin)
end
function c123210.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and e:GetHandler():GetFlagEffectLabel(36690018)==1
end
function c123210.cttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c123210.ctop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c123210.ctcon2(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer() and e:GetHandler():GetFlagEffectLabel(36690018)==0
end
function c123210.cttg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c123210.ctop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
