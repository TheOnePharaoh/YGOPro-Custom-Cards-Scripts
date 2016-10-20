--Earthbound Immortal Islu and Mulcus
function c92377562.initial_effect(c)
	c:SetUniqueOnField(1,0,92377562)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x21),4,2)
	c:EnableReviveLimit()
	--self destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(c92377562.sdcon)
	c:RegisterEffect(e1)
	--battle target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--direct atk
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e3)
	--overlay capture or destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLED)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(c92377562.atcon)
	e4:SetOperation(c92377562.atop)
	c:RegisterEffect(e4)
	--damage
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(92377562,0))
	e5:SetCategory(CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetCost(c92377562.damcost)
	e5:SetTarget(c92377562.damtg)
	e5:SetOperation(c92377562.damop)
	c:RegisterEffect(e5)
end
function c92377562.sdcon(e)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	local f1=Duel.GetFieldCard(0,LOCATION_SZONE,5)
	local f2=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return ((f1==nil or not f1:IsFaceup()) and (f2==nil or not f2:IsFaceup()))
end
function c92377562.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c92377562.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if bc:IsFaceup() and bc:IsType(TYPE_MONSTER) and not bc:IsType(TYPE_XYZ) then
		Duel.Overlay(c,bc)
	end
end
function c92377562.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,99,REASON_COST)
	local ct=Duel.GetOperatedGroup():GetCount()
	e:SetLabel(ct)
end
function c92377562.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ct=e:GetLabel()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*500)
end
function c92377562.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=e:GetLabel()
	Duel.Damage(p,ct*500,REASON_EFFECT)
end
