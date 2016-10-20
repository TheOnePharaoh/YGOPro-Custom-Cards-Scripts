--Dreadnought Mark - Z02 Grad
function c22769914.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_WIND),10,2)
	c:EnableReviveLimit()
	--spsummon limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e1)
	--cannot be effect target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	--spell cannot be negated
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_INACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c22769914.dscon)
	e3:SetValue(c22769914.chainfilter)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_DISEFFECT)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c22769914.dscon)
	e4:SetValue(c22769914.chainfilter)
	c:RegisterEffect(e4)
	--get effect
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(22769914,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCost(c22769914.cost)
	e5:SetTarget(c22769914.target)
	e5:SetOperation(c22769914.operation)
	c:RegisterEffect(e5)
end
function c22769914.dscon(e)
	return e:GetHandler():GetOverlayCount()~=0
end
function c22769914.chainfilter(e,ct)
	local p=e:GetHandlerPlayer()
	local te,tp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tc=te:GetHandler()
	return p==tp and tc:IsType(TYPE_TRAP+TYPE_COUNTER)
end
function c22769914.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22769914.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(22769914)==0 or c:GetFlagEffect(22769914)==0 end
	local t1=c:GetFlagEffect(22769914)
	local t2=c:GetFlagEffect(22769914)
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22769914,0))
	if t1==0 and t2==0 then
		op=Duel.SelectOption(tp,aux.Stringid(22769914,1),aux.Stringid(22769914,2))
	elseif t1==0 then op=Duel.SelectOption(tp,aux.Stringid(22769914,1))
	else Duel.SelectOption(tp,aux.Stringid(22769914,2)) op=1 end
	e:SetLabel(op)
	if op==0 then c:RegisterFlagEffect(22769914,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	else c:RegisterFlagEffect(22769914,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1) end
end
function c22769914.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(22769914,3))
		e1:SetCategory(CATEGORY_DESTROY)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_BATTLE_START)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		e1:SetCondition(c22769914.descon)
		e1:SetTarget(c22769914.destg)
		e1:SetOperation(c22769914.desop)
		c:RegisterEffect(e1)
	else
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c22769914.efilter)
		c:RegisterEffect(e1)
	end
end
function c22769914.descon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	if d==e:GetHandler() then d=Duel.GetAttacker() end
	e:SetLabelObject(d)
	return d~=nil
end
function c22769914.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetLabelObject(),1,0,0)
end
function c22769914.desop(e,tp,eg,ep,ev,re,r,rp)
	local d=e:GetLabelObject()
	if d:IsRelateToBattle() then
		Duel.Destroy(d,REASON_EFFECT)
	end
end
function c22769914.efilter(e,re)
	return re:GetOwner():IsType(TYPE_TRAP)
end
