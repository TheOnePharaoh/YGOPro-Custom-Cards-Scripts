--Vocaloid Namine Ritsu
function c22874081.initial_effect(c)
	c:SetUniqueOnField(1,0,22874081)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_SINGLE_RANGE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.synlimit)
	c:RegisterEffect(e1)
	--atk def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTarget(c22874081.tg)
	e2:SetValue(300)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--cannot be battle target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e4:SetCondition(c22874081.con)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	--atk/def
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e5:SetCondition(c22874081.adcon)
	e5:SetCost(c22874081.adcost)
	e5:SetOperation(c22874081.adop)
	c:RegisterEffect(e5)
end
function c22874081.tg(e,c)
	return c:IsType(TYPE_SYNCHRO)
end
function c22874081.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac402) and not c:IsCode(22874080)
end
function c22874081.con(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(c22874081.filter,c:GetControler(),LOCATION_MZONE,0,1,c)
end
function c22874081.adcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsFaceup() and not bc:IsRace(RACE_MACHINE)
end
function c22874081.adcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end
function c22874081.adop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(0)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		bc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		bc:RegisterEffect(e2)
	end
end