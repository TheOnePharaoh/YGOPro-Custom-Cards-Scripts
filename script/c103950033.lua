--The Chosen Paragon
function c103950033.initial_effect(c)
	--Gain Life Points
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950033,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c103950033.target)
	e1:SetOperation(c103950033.activate)
	c:RegisterEffect(e1)
end
function c103950033.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	local tc = g:GetFirst()
	local atk = tc:GetAttack()
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,g,1,PLAYER_ALL,atk)
end
function c103950033.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Card.IsFaceup(tc) then
		local atk = tc:GetAttack()
		Duel.Recover(tp,atk,REASON_EFFECT)
		Duel.Recover(1-tp,atk,REASON_EFFECT)
		local e1=Effect.CreateEffect(tc)
		e1:SetDescription(aux.Stringid(103950033,1))
		e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetCondition(c103950033.atkcon)
		e1:SetOperation(c103950033.atkop)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EVENT_BE_BATTLE_TARGET)
		tc:RegisterEffect(e2)
		if Duel.GetAttackTarget()==tc or Duel.GetAttacker()==tc then
			Duel.NegateAttack()
		end
	end
end
function c103950033.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttackTarget()==c or Duel.GetAttacker()==c
end
function c103950033.atkop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end
