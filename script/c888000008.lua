--Evil HERO Swamp Demon
function c888000008.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,79979666,84327329,true,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(c888000008.splimit)
	c:RegisterEffect(e1)
	--to defense
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetCondition(c888000008.poscon)
	e2:SetOperation(c888000008.posop)
	c:RegisterEffect(e2)
	--change battle target
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(888000008,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c888000008.cbcon)
	e3:SetOperation(c888000008.cbop)
	c:RegisterEffect(e3)
end
c888000008.dark_calling=true
function c888000008.splimit(e,se,sp,st)
	return st==SUMMON_TYPE_FUSION+0x10
end
function c888000008.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() and e:GetHandler():IsRelateToBattle()
end
function c888000008.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
function c888000008.cbcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bt=eg:GetFirst()
	return c~=bt and bt:GetControler()==c:GetControler()
end
function c888000008.cbop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeAttackTarget(e:GetHandler())
end