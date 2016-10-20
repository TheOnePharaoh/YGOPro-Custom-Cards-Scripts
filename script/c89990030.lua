--mystical sword
function c89990030.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c89990030.target)
	e1:SetOperation(c89990030.activate)
	c:RegisterEffect(e1)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetValue(400)
	c:RegisterEffect(e2)
	--Equip limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c89990030.eqlimit)
	c:RegisterEffect(e3)
	--discard, todeck, draw
	local e4=Effect.CreateEffect(c)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_DAMAGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c89990030.damcon)
	e4:SetOperation(c89990030.damop)
	c:RegisterEffect(e4)
end
function c89990030.eqlimit(e,c)
	return c:IsSetCard(0x22b)
end
function c89990030.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x22b)
end
function c89990030.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c89990030.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c89990030.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c89990030.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function c89990030.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end
function c89990030.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and Duel.GetAttackTarget()==nil and e:GetHandler():GetEquipTarget():IsRelateToBattle()
end
function c89990030.damop(e,tp,eg,ep,ev,re,r,rp)
	Duel.DiscardHand(tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	Duel.DiscardHand(1-tp,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
	local g1=Duel.SelectMatchingCard(1-tp,Card.IsAbleToDeck,1-tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SendtoDeck(g1,nil,0,REASON_EFFECT)
	Duel.SendtoDeck(g2,nil,0,REASON_EFFECT)
	Duel.ShuffleDeck(tp)
	Duel.ShuffleDeck(1-tp)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
	Duel.Draw(1-tp,1,REASON_EFFECT)
end
