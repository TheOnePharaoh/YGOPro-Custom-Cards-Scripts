--Legendary Wyrm Mecha Dynamo
function c77777841.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	aux.AddFusionProcFunFunRep(c,aux.FilterBoolFunction(Card.IsFusionSetCard,0x409),aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),1,1,true)
	--actlimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1)
	e4:SetValue(c77777841.aclimit)
	e4:SetCondition(c77777841.actcon)
	c:RegisterEffect(e4)
	--spsummon success
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c77777841.succon)
	e3:SetOperation(c77777841.sucop)
	c:RegisterEffect(e3)
end
function c77777841.succon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_FUSION
		and Duel.IsExistingMatchingCard(c77777841.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c77777841.filter(c)
	return c:IsRace(RACE_MACHINE) and c:IsFaceup()and c:IsDestructable()
end
function c77777841.filter2(c)
	return c:IsRace(RACE_MACHINE) and c:IsFaceup()and c:IsAbleToRemove()
end
function c77777841.sucop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c77777841.filter,tp,LOCATION_MZONE,LOCATION_MZONE,e:GetHandler())
	local count=g:GetCount()
	if Duel.Destroy(g,REASON_EFFECT,LOCATION_REMOVED)~=0 then
	local g2=Duel.GetMatchingGroup(c77777841.filter2,tp,LOCATION_EXTRA,LOCATION_EXTRA,e:GetHandler())
	count=count+g2:GetCount()
	Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetValue(count*600)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
	end
end

function c77777841.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c77777841.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
