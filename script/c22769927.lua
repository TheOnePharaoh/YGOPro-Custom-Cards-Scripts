--Dreadnought Mark - Z04 Leon
function c22769927.initial_effect(c)
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
	--recover&destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c22769927.dscon)
	e3:SetOperation(c22769927.drop)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(22769927,0))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(c22769927.damcon)
	e4:SetCost(c22769927.damcost)
	e4:SetTarget(c22769927.damtg)
	e4:SetOperation(c22769927.damop)
	c:RegisterEffect(e4)
end
function c22769927.dscon(e)
	return e:GetHandler():GetOverlayCount()~=0
end
function c22769927.dfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c22769927.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:GetHandler():IsType(TYPE_COUNTER) or not c:IsLocation(LOCATION_MZONE) or not c:IsFaceup() then return end
	Duel.Recover(tp,1000,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c22769927.dfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c22769927.damcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c:IsRelateToBattle() and bc:IsLocation(LOCATION_GRAVE) and bc:IsType(TYPE_MONSTER)
end
function c22769927.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c22769927.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local dam=bc:GetAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c22769927.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
