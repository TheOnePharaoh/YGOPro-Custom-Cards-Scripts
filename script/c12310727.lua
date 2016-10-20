--Havel the Rock
--lua script by SGJin
function c12310727.initial_effect(c)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_DECK)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	-- Uneffected by opponent's spell cards (Great Magic Barrier: Havel Hates magic users!)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c12310727.efilter)
	c:RegisterEffect(e2)
	--Can't stop the Rock
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetOperation(c12310727.op)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12310727,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetCondition(c12310727.descon)
	e4:SetTarget(c12310727.destg)
	e4:SetOperation(c12310727.desop)
	c:RegisterEffect(e4)
end
function c12310727.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c12310727.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c12310727.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c12310727.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c12310727.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_PENDULUM
end
function c12310727.filter(c)
	return c:IsFacedown() and c:IsDestructable()
end
function c12310727.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and c12310727.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12310727.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c12310727.filter,tp,0,LOCATION_ONFIELD,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c12310727.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local dg=g:Filter(Card.IsRelateToEffect,nil,e)
	Duel.Destroy(dg,REASON_EFFECT)
end
