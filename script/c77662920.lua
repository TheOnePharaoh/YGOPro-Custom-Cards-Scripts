--Vocaloid IA Second Melody - A Tune of Harmony
function c77662920.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),4,2)
	c:EnableReviveLimit()
	--negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(77662920,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c77662920.condition)
	e1:SetCost(c77662920.cost)
	e1:SetTarget(c77662920.target)
	e1:SetOperation(c77662920.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetDescription(aux.Stringid(77662920,1))
	e2:SetCondition(c77662920.condition2)
	c:RegisterEffect(e2)
	--atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c77662920.atkcon)
	e3:SetOperation(c77662920.atkop)
	c:RegisterEffect(e3)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c77662920.aclimit)
	e4:SetCondition(c77662920.actcon)
	c:RegisterEffect(e4)
end
function c77662920.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return re:IsActiveType(TYPE_XYZ) and rc~=c and rc:IsRankBelow(5) and loc==LOCATION_MZONE
		and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c77662920.condition2(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	local c=e:GetHandler()
	return re:IsActiveType(TYPE_XYZ) and tc:IsRace(RACE_MACHINE) and tc:IsLocation(LOCATION_MZONE)
		and not c:IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c77662920.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c77662920.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c77662920.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	local rc=re:GetHandler()
	if rc:IsRelateToEffect(re) then 
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
function c77662920.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0 and re and re:GetHandler()==e:GetHandler()
		and eg:IsExists(Card.IsType,1,nil,TYPE_MONSTER)
end
function c77662920.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.IsType,nil,TYPE_MONSTER)
	local c=e:GetHandler()
	local atk=0
	local tc=g:GetFirst()
	while tc do
		if tc:GetTextAttack()>0 then
			atk=atk+tc:GetTextAttack()
		end
		tc=g:GetNext()
	end
	if atk>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c77662920.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c77662920.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
