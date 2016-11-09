--Predator Plant Junglolem
function c195200026.initial_effect(c)
	--fusion
  c:EnableReviveLimit()
  aux.AddFusionProcFunRep(c,c195200026.mat_filter,2,false)
	--atk,def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c195200026.val)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(63253763,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c195200026.cttg)
	e2:SetOperation(c195200026.ctop)
	c:RegisterEffect(e2)

end
function c195200026.mat_filter(c)
  return c:IsAttribute(ATTRIBUTE_DARK) and c:IsRace(RACE_PLANT)
end

function c195200026.val(e,c)
	return Duel.GetCounter(0,1,1,0x1041)*200
end
function c195200026.cttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
end
function c195200026.ctop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	while tc do
		tc:AddCounter(0x1041,1)
		tc=g:GetNext()
	end
	--
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetTarget(c195200026.lvtg)
	e3:SetValue(1)
	Duel.RegisterEffect(e3,0)
end
function c195200026.lvtg(e,c)
	return c:GetCounter(0x1041)>0 and c:IsLevelAbove(1)
end