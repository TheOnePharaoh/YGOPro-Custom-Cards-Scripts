--Evil 1
function c512000091.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)	
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_BATTLE_START)
	e1:SetCondition(c512000091.condition)
	e1:SetOperation(c512000091.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511000186,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCost(c512000091.descost)
	e2:SetTarget(c512000091.destg)
	e2:SetOperation(c512000091.desop)
	c:RegisterEffect(e2)
end
function c512000091.condition(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d~=nil and d:IsFaceup() and Duel.GetLP(e:GetHandler():GetControler())<=Duel.GetLP(1-e:GetHandler():GetControler())-6000
	and not Duel.IsDamageCalculated()
end
function c512000091.activate(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local c=e:GetHandler()
	local p=c:GetControler()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE)
	d:RegisterEffect(e1)
	local e2=e1:Clone()
	a:RegisterEffect(e2)
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetOperation(c512000091.dop)
	e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
	a:RegisterEffect(e3)
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	local e4=Effect.CreateEffect(e:GetHandler())
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetCountLimit(1)
	e4:SetCondition(c512000091.losecon)
	e4:SetOperation(c512000091.loseop)
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_END then
			e4:SetLabel(2)
		else e4:SetLabel(1) end
	Duel.RegisterEffect(e4,tp)
end
function c512000091.dop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p=c:GetControler()
	local lp1=Duel.GetLP(p)-1
	local lp2=Duel.GetLP(1-p)-1
	Duel.ChangeBattleDamage(p,lp1)
	Duel.ChangeBattleDamage(1-p,lp2)	
end
function c512000091.losecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetTurnCount()~=e:GetLabel()
end
function c512000091.loseop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local WIN_REASON_EVIL_1=0x51
	if ct<=0 then
		Duel.Win(1-tp,WIN_REASON_EVIL_1)
	else
		e:SetLabel(ct-1)
	end
end
function c512000091.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() 
	and Duel.GetCurrentPhase()==PHASE_MAIN1 end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_BP)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c512000091.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c512000091.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
