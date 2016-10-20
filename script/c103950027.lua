--Tremor Draco
function c103950027.initial_effect(c)
	
	--Not destroyed by battle
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(103950027,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FLIP)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(c103950027.btcon)
	e1:SetOperation(c103950027.btop)
	c:RegisterEffect(e1)
	
	--Flip Field Spells face-down
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(103950027,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c103950027.fstgt)
	e2:SetOperation(c103950027.fsop)
	e2:SetCountLimit(1)
	c:RegisterEffect(e2)
	
end

--Not destroyed by battle condition
function c103950027.btcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker()
end

--Not destroyed by battle operation
function c103950027.btop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	if c:IsFaceup() then
		
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e1)
		
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e2:SetCode(EVENT_BATTLE_END)
		e2:SetTarget(c103950027.bptgt)
		e2:SetOperation(c103950027.bpop)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
		Duel.RegisterEffect(e2,tp)
	end
end

--Change battle position target
function c103950027.bptgt(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=e:GetOwner():GetBattleTarget()
	
	if chk==0 then return tg end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,tg,1,0,0)
end

--Change battle position operation
function c103950027.bpop(e,tp,eg,ep,ev,re,r,rp)
	local tg=e:GetOwner():GetBattleTarget()
	if tg then
		Duel.ChangePosition(tg,POS_FACEUP_DEFENSE,POS_FACEDOWN_DEFENSE,0,0)
	end
end

--Flip Field Spells filter
function c103950027.fsfilter(c)
	return c:IsType(TYPE_FIELD) and c:IsFaceup()
end

--Flip Field Spells target
function c103950027.fstgt(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c103950027.fsfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	
	local g=Duel.GetMatchingGroup(c103950027.fsfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,g:GetCount(),0,0)
end

--Flip Field Spells operation
function c103950027.fsop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c103950027.fsfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g:GetCount() <= 0 then return end
	
	Duel.ChangePosition(g,POS_FACEDOWN)
	
	local tc=g:GetFirst()
	local e1 = nil
	
	while tc do
		e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	
		tc=g:GetNext()
	end
end