--No. 28: Colossal Warrior N.A.N.O Blaster
function c78219316.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),2,2)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c78219316.dacon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(78219316,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_RECOVER)
	e3:SetCondition(c78219316.cd)
	e3:SetOperation(c78219316.op)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c78219316.discon)
	e4:SetCost(c78219316.discost)
	e4:SetTarget(c78219316.distg)
	e4:SetOperation(c78219316.disop)
	c:RegisterEffect(e4)
	--send replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e5:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e5:SetCondition(c78219316.repcon)
	e5:SetOperation(c78219316.repop)
	c:RegisterEffect(e5)
	--draw
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(78219316,1))
	e6:SetCategory(CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCountLimit(1)
	e6:SetCondition(c78219316.con)
	e6:SetTarget(c78219316.tg)
	e6:SetOperation(c78219316.ope)
	c:RegisterEffect(e6)
end
c78219316.xyz_number=28
function c78219316.dacon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c78219316.cd(e,tp,eg,ep,ev,re,r,rp)
	return tp==ep
end
function c78219316.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,500,REASON_EFFECT)
end
function c78219316.discon(e,tp,eg,ep,ev,re,r,rp)
	return re~=e and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c78219316.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c78219316.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c78219316.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c78219316.repcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c78219316.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	Duel.RaiseEvent(c,EVENT_CUSTOM+78219316,e,0,tp,0,0)
end
function c78219316.gfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_XYZ) and c:IsControler(tp)
end
function c78219316.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c78219316.gfilter,1,nil,tp)
end
function c78219316.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c78219316.ope(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
