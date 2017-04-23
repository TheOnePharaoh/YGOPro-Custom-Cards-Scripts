--RUM The Chosen One
function c59821161.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c59821161.condition)
	e1:SetTarget(c59821161.target)
	e1:SetOperation(c59821161.operation)
	c:RegisterEffect(e1)
	--add setcode
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_ADD_SETCODE)
	e2:SetValue(0x95)
	c:RegisterEffect(e2)
	--act in hand
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e3:SetCondition(c59821161.handcon)
	c:RegisterEffect(e3)
end
function c59821161.handcon(e)
	return tp~=Duel.GetTurnPlayer()
end
function c59821161.condition(e,tp,eg,ev,ep,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a and a:IsControler(1-tp) then
		a=Duel.GetAttackTarget()
		d=Duel.GetAttacker()
	end
	return Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<PHASE_MAIN2 and a and a:IsSetCard(0xa1a2) and a:IsType(TYPE_XYZ) and a:GetRank()==4
end
function c59821161.target(e,tp,eg,ev,ep,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a and a:IsControler(1-tp) then
		a=Duel.GetAttackTarget()
		d=Duel.GetAttacker()
	end
	if chk==0 then return not a:IsImmuneToEffect(e) end
	local fg=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	fg:RemoveCard(e:GetHandler())
	local fc=fg:GetFirst()
	while fc do
		fc:RegisterFlagEffect(59821161,RESET_PHASE+PHASE_END,0,1)
		fc=fg:GetNext()
	end
	Duel.SetTargetCard(a)
end
function c59821161.operation(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetFirstTarget()
	if not a then return end
	local b=a:GetBattleTarget()
	if b then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCountLimit(1)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		a:RegisterEffect(e1)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetTargetRange(0,0xff)
	e2:SetTarget(c59821161.disable)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetCode(EFFECT_DISABLE)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DAMAGE_STEP_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c59821161.conditionskipxyz)
	e3:SetTarget(c59821161.targetskip)
	e3:SetOperation(c59821161.operationskip)
	e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	a:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetCode(EVENT_PHASE_START+PHASE_MAIN2)
	e4:SetTarget(c59821161.targetxyz)
	e4:SetOperation(c59821161.operationxyz)
	a:RegisterEffect(e4)
end
function c59821161.disable(e,c)
	return c:IsFaceup() and c:GetFlagEffect(59821161)~=0
end
function c59821161.conditionskipxyz(e,tp,eg,ev,ep,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()~=0
end
function c59821161.targetskip(e,tp,eg,ev,ep,re,r,rp,chk)
	if chk==0 then return true end
end
function c59821161.operationskip(e,tp,eg,ev,ep,re,r,rp)
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
end
function c59821161.filter(c,e,tp,mc)
	if c:IsCode(6165656) and code~=48995978 then return false end
	return c:GetRank()==mc:GetRank()+1 and c:IsSetCard(0xa1a2) and c:IsType(TYPE_XYZ) and mc:IsCanBeXyzMaterial(c) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c59821161.targetxyz(e,tp,eg,ev,ep,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c59821161.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,e:GetHandler()) end
end
function c59821161.operationxyz(e,tp,eg,ev,ep,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.SelectMatchingCard(tp,c59821161.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,e:GetHandler())
	local sc=sg:GetFirst()
	if sc then
		local mg=c:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(c))
		Duel.Overlay(sc,Group.FromCards(c))
		Duel.SpecialSummon(sc,TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		sc:CompleteProcedure()
	end
end