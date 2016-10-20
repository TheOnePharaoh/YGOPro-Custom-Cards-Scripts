--Voidstorm Dragon
function c103950021.initial_effect(c)

	--Synchro Summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_DRAGON),1)
	c:EnableReviveLimit()
	
	--Halve ATK and DEF
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950021,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c103950021.atkcon)
	e1:SetOperation(c103950021.atkop)
	c:RegisterEffect(e1)
	
	--Multi-attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	e2:SetCondition(c103950021.matcon)
	c:RegisterEffect(e2)
end

--Halve ATK and DEF condition
function c103950021.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget()~=nil and Duel.GetAttackTarget():IsFaceup()
end

--Halve ATK and DEF operation
function c103950021.atkop(e,tp,eg,ep,ev,re,r,rp)

	local tc = Duel.GetAttackTarget()
	if tc == nil then return end
	
	if tc:IsFaceup() then
	
		local atk=tc:GetAttack()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(atk/2)
		tc:RegisterEffect(e1)
		
		local def=tc:GetDefense()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(def/2)
		tc:RegisterEffect(e1)
	end
end

--Multi-attack filter
function c103950021.matfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end

--Multi-attack condition
function c103950021.matcon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),0,LOCATION_MZONE)>0
			and Duel.IsExistingMatchingCard(c103950021.matfilter,e:GetHandlerPlayer(),LOCATION_REMOVED,0,3,nil)
end