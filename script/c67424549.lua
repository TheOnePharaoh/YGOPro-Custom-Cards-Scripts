--Predator's Seed
function c67424549.initial_effect(c)
	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetTarget(c67424549.target)
	e1:SetOperation(c67424549.operation)
	c:RegisterEffect(e1)
end

function c67424549.cfil(c)
  return c:IsAttackPos() 
end
function c67424549.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=eg:GetFirst()
	local a=Duel.GetAttacker()
	if chk==0 then return at:IsControler(tp) and at:IsOnField() and at:IsFaceup() and at:IsRace(RACE_PLANT)	and a:IsOnField() and Duel.IsExistingMatchingCard(c67424549.cfil,tp,0,LOCATION_MZONE,1,nil) end
	at:CreateEffectRelation(e)
	a:CreateEffectRelation(e)
end
function c67424549.operation(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c67424549.cfil,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
		tc:AddCounter(0x1041,1)
		if tc:GetAttack()>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(-300)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetCondition(c67424549.atkcon)
		tc:RegisterEffect(e1)
		end
			tc=g:GetNext()
		end
       end
end
function c67424549.atkcon(e)
	return e:GetHandler():GetCounter(0x1041)>0
end