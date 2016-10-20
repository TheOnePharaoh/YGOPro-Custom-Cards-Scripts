--Galaco, the enforcer of vocaloids
function c11111123.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11111123,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c11111123.ntcon)
	c:RegisterEffect(e1)
	--act limit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetOperation(c11111123.chainop)
	c:RegisterEffect(e2)
	--cannot be target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetTarget(c11111123.tgtg)
	e3:SetValue(aux.tgoval)
	c:RegisterEffect(e3)
end
function c11111123.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x0dac401)
end
function c11111123.ntcon(e,c,minc)
	if c==nil then return true end
	return minc==0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c11111123.filter,c:GetControler(),LOCATION_MZONE,0,1,nil)
end

function c11111123.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and rc:IsSetCard(0x0dac401) and re:IsActiveType(TYPE_SPELL) then
		Duel.SetChainLimit(c11111123.chainlm)
	end
end
function c11111123.chainlm(e,rp,tp)
	return tp==rp
end
function c11111123.tgtg(e,c)
	return c:IsSetCard(0x0dac401) and c:IsType(TYPE_RITUAL)
end
