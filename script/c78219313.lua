--Colossal Warrior - Armored Knight
function c78219313.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),2,3,c78219313.ovfilter,aux.Stringid(78219313,0))
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c78219313.aclimit)
	e1:SetCondition(c78219313.actcon)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetCondition(c78219313.dacon)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--send replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_TO_GRAVE_REDIRECT_CB)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetCondition(c78219313.repcon)
	e3:SetOperation(c78219313.repop)
	c:RegisterEffect(e3)
	--lp gain
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_RECOVER)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCost(c78219313.lpcost)
	e4:SetTarget(c78219313.lptg)
	e4:SetOperation(c78219313.lpop)
	c:RegisterEffect(e4)
end
function c78219313.ovfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x7ad30) and c:IsType(TYPE_XYZ)
end
function c78219313.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c78219313.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c78219313.dacon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsSetCard,1,nil,0x7ad30)
end
function c78219313.repcon(e)
	local c=e:GetHandler()
	return c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReason(REASON_DESTROY)
end
function c78219313.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	Duel.RaiseEvent(c,EVENT_CUSTOM+78219313,e,0,tp,0,0)
end
function c78219313.lpfilter(g,tp)
	local c=g:GetFirst()
	if c:IsControler(1-tp) then c=g:GetNext() end
	if c and c:IsAttribute(ATTRIBUTE_DARK) and c:IsLocation(LOCATION_GRAVE) then return c end
	return nil
end
function c78219313.lpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local rc=c78219313.lpfilter(eg,tp)
		return rc and rc:IsAbleToRemoveAsCost()
	end
	local rc=c78219313.lpfilter(eg,tp)
	e:SetLabel(rc:GetAttack())
	Duel.Remove(rc,POS_FACEUP,REASON_EFFECT)
end
function c78219313.lptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel())
end
function c78219313.lpop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
