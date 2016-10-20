--No. C28: Colossal Warrior Mega N.A.N.O Blaster
function c78219318.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),3,4)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c78219318.dacon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(78219318,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_RECOVER)
	e3:SetCondition(c78219318.cd)
	e3:SetOperation(c78219318.op)
	c:RegisterEffect(e3)
	--negate
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_DISABLE+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c78219318.discon)
	e4:SetCost(c78219318.discost)
	e4:SetTarget(c78219318.distg)
	e4:SetOperation(c78219318.disop)
	c:RegisterEffect(e4)
	--destroy & draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(78219318,1))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCondition(c78219318.descon)
	e5:SetCost(c78219318.descost)
	e5:SetTarget(c78219318.destg)
	e5:SetOperation(c78219318.desop)
	c:RegisterEffect(e5)
	--send replace
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e6:SetCondition(c78219318.repcon)
	e6:SetOperation(c78219318.repop)
	c:RegisterEffect(e6)
	--draw
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(78219318,2))
	e7:SetCategory(CATEGORY_DRAW)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetRange(LOCATION_SZONE)
	e7:SetCountLimit(1)
	e7:SetCondition(c78219318.con)
	e7:SetTarget(c78219318.tg)
	e7:SetOperation(c78219318.ope)
	c:RegisterEffect(e7)
	--add setcode
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EFFECT_ADD_SETCODE)
	e8:SetValue(0x1048)
	c:RegisterEffect(e8)
end
c78219318.xyz_number=28
function c78219318.dacon(e)
	return e:GetHandler():GetOverlayCount()>0
end
function c78219318.cd(e,tp,eg,ep,ev,re,r,rp)
	return tp==ep
end
function c78219318.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,700,REASON_EFFECT)
end
function c78219318.discon(e,tp,eg,ep,ev,re,r,rp)
	return re~=e and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and (re:IsActiveType(TYPE_MONSTER) or re:IsHasType(EFFECT_TYPE_ACTIVATE)) and Duel.IsChainNegatable(ev)
end
function c78219318.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c78219318.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c78219318.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c78219318.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,78219316)
end
function c78219318.costfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7ad30) and c:IsAbleToGraveAsCost()
end
function c78219318.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c78219318.costfilter,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c78219318.costfilter,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c78219318.desfilter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c78219318.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c78219318.desfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c78219318.desfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c78219318.desfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	
end
function c78219318.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local p=tc:GetControler()
		if Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end
function c78219318.repcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c78219318.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	Duel.RaiseEvent(c,EVENT_CUSTOM+78219318,e,0,tp,0,0)
end
function c78219318.gfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_DARK) and c:IsType(TYPE_XYZ) and c:IsControler(tp)
end
function c78219318.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c78219318.gfilter,1,nil,tp)
end
function c78219318.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c78219318.ope(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
