--Necromantic Shadow Master
function c77777736.initial_effect(c)
	--Draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77777736,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetTarget(c77777736.drtg)
	e1:SetOperation(c77777736.drop)
	c:RegisterEffect(e1)
	--become material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c77777736.condition)
	e2:SetOperation(c77777736.operation)
	c:RegisterEffect(e2)
end

function c77777736.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c77777736.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end

function c77777736.condition(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_RITUAL
end
function c77777736.operation(e,tp,eg,ep,ev,re,r,rp)
	local rc=eg:GetFirst()
	if rc:IsSetCard(0x1c8)then
	while rc do
		if rc:GetFlagEffect(77777736)==0 then
			--atkdown
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_QUICK_F+EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e2:SetDescription(aux.Stringid(77777736,1))
		e2:SetCategory(CATEGORY_ATKCHANGE)
		e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetCondition(c77777736.con)
		e2:SetOperation(c77777736.op)
		rc:RegisterEffect(e2,true)
		rc:RegisterFlagEffect(77777736,RESET_EVENT+0x1fe0000,0,1)
		end
		rc=eg:GetNext()
	end
	end
end

function c77777736.con(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return a==e:GetHandler() and d and d:IsLevelBelow(e:GetHandler():GetOriginalLevel())
end
function c77777736.op(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a:IsRelateToBattle() or a:IsFacedown() or not d:IsRelateToBattle() or d:IsFacedown() then return end
	if a:IsControler(1-tp) then a,d=d,a end
	local e1=Effect.CreateEffect(e:GetHandler())
--	e1:SetOwnerPlayer(tp)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
	e1:SetValue(0)
	d:RegisterEffect(e1)
end

