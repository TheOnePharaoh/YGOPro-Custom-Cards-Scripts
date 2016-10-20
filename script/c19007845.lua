--Mechquipped Jackal
function c19007845.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c19007845.atktg)
	e2:SetValue(200)
	c:RegisterEffect(e2)
	--def up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c19007845.atktg)
	e3:SetValue(200)
	c:RegisterEffect(e3)
	--change battle_pos
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,0x1e0)
	e4:SetTarget(c19007845.postg)
	e4:SetOperation(c19007845.posop)
	c:RegisterEffect(e4)
	--Negate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(19007845,0))
	e5:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c19007845.condition)
	e5:SetTarget(c19007845.target)
	e5:SetOperation(c19007845.operation)
	c:RegisterEffect(e5)
	--lp gain
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_RECOVER)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCode(EVENT_CHANGE_POS)
	e6:SetCountLimit(1,19007845)
	e6:SetCondition(c19007845.poscon)
	e6:SetTarget(c19007845.lptg)
	e6:SetOperation(c19007845.lpop)
	c:RegisterEffect(e6)
end
function c19007845.atktg(e,c)
	return c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c19007845.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DEFENSE)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function c19007845.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
	end
end
function c19007845.condition(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) or not Duel.IsChainNegatable(ev) then return false end
	if re:IsHasCategory(CATEGORY_NEGATE)
		and Duel.GetChainInfo(ev-1,CHAININFO_TRIGGERING_EFFECT):IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	return ex and tg~=nil and tc+tg:FilterCount(Card.IsOnField,nil)-tg:GetCount()>0
end
function c19007845.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c19007845.operation(e,tp,eg,ep,ev,re,r,rp)
  local c=e:GetHandler()
  if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 or not c:IsRelateToEffect(e) then return end
  if Duel.ChangePosition(c,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)>0 then
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
  end
end
function c19007845.poscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return bit.band(c:GetPreviousPosition(),POS_DEFENSE)~=0 and c:IsFaceup() and c:IsAttackPos() or bit.band(c:GetPreviousPosition(),POS_ATTACK)~=0 and c:IsFaceup() and c:IsDefensePos()
end
function c19007845.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(800)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,800)
end
function c19007845.lpop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end

