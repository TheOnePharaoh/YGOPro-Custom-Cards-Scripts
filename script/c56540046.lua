function c56540046.initial_effect(c)
local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c56540046.condition)
	e3:SetTarget(c56540046.target)
	e3:SetOperation(c56540046.operation)
	c:RegisterEffect(e3)
local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetCountLimit(1)
	e2:SetValue(c56540046.valcon)
	c:RegisterEffect(e2)
local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_UPDATE_ATTACK)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget( c56540046.indtg)
	e4:SetValue(500)
	c:RegisterEffect(e4)
end
function c56540046.condition(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp or r~=REASON_BATTLE then return false end
	local rc=eg:GetFirst()
	return rc:IsControler(tp)
end
function c56540046.valcon(e,re,r,rp)
	return bit.band(r,REASON_EFFECT)~=0
end
function c56540046.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end
function c56540046.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.Draw(tp,1,REASON_EFFECT)  
end
function c56540046.indtg(e,c)
	return c:IsType(TYPE_MONSTER)
end