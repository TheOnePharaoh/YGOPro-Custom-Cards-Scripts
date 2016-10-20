--The Future Gear Alma the Warlock
function c99199027.initial_effect(c)
	c:SetSPSummonOnce(99199027)
	--fusion material
	aux.AddFusionProcFun2(c,c99199027.mfilter1,c99199027.mfilter2,true)
	c:EnableReviveLimit()
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--attack all
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ATTACK_ALL)
	e3:SetValue(c99199027.atkfilter)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(99199027,0))
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c99199027.cost)
	e4:SetTarget(c99199027.target)
	e4:SetOperation(c99199027.operation)
	c:RegisterEffect(e4)
end
c99199027.material_setcode=0xff15
function c99199027.mfilter1(c)
	return c:IsFusionSetCard(0xff15) and c:IsType(TYPE_PENDULUM) and c:GetLevel()==6
end
function c99199027.mfilter2(c)
	return c:IsFusionSetCard(0xff15) and c:IsType(TYPE_PENDULUM) and c:GetLevel()==4
end
function c99199027.atkfilter(e,c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_NORMAL)==SUMMON_TYPE_NORMAL
end
function c99199027.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT) end
	local sg=Duel.SelectReleaseGroup(tp,Card.IsAttribute,1,1,nil,ATTRIBUTE_LIGHT)
	local atk=sg:GetFirst():GetTextAttack()
	if atk<0 then atk=0 end
	e:SetLabel(atk)
	Duel.Release(sg,REASON_COST)
end
function c99199027.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel())
end
function c99199027.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end