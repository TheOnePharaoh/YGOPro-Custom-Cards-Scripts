--Mechquipped Wolfang
function c19007842.initial_effect(c)
	--to defense
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c19007842.poscon)
	e1:SetOperation(c19007842.posop)
	c:RegisterEffect(e1)
	--shuffle&draw
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_CHANGE_POS)
	e2:SetCountLimit(1,19007842)
	e2:SetCondition(c19007842.poscon)
	e2:SetTarget(c19007842.drtarg)
	e2:SetOperation(c19007842.drop)
	c:RegisterEffect(e2)
	--cannot be battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetCondition(c19007842.con)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c19007842.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetAttackedCount()>0
end
function c19007842.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_COPY_INHERIT)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,3)
	c:RegisterEffect(e1)
end
function c19007842.poscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetPreviousPosition(),POS_DEFENSE)~=0 and c:IsFaceup() and c:IsAttackPos() or bit.band(c:GetPreviousPosition(),POS_ATTACK)~=0 and c:IsFaceup() and c:IsDefensePos()
end
function c19007842.drafilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsLevelBelow(4) and c:IsSetCard(0xda3791) or c:IsSetCard(0xda3790) or c:IsCode(15914410) or c:IsCode(41309158) and c:IsAbleToDeck()
end
function c19007842.drtarg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c19007842.drafilter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingTarget(c19007842.drafilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c19007842.drafilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c19007842.drop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=2 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==2 then
		Duel.ShuffleDeck(tp)
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
function c19007842.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0xda3791) or c:IsCode(15914410) or c:IsCode(41309158) and not c:IsCode(19007842)
end
function c19007842.con(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c19007842.confilter,c:GetControler(),LOCATION_MZONE,0,1,c)
end
