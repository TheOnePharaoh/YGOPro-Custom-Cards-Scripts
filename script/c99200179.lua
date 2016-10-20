--Android's D.N.A. Extraction
function c99200179.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c99200179.target)
	c:RegisterEffect(e1)
	--race
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCode(EFFECT_CHANGE_RACE)
	e2:SetValue(c99200179.value)
	c:RegisterEffect(e2)
	e1:SetLabelObject(e2)
	--draw
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetOperation(c99200179.drop)
	c:RegisterEffect(e3)
	--self destruct
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_DESTROY)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c99200179.descon)
	e4:SetOperation(c99200179.desop)
	c:RegisterEffect(e4)
end
function c99200179.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,563)
	local rc=Duel.AnnounceRace(tp,1,0xffffff)
	e:GetLabelObject():SetLabel(rc)
	e:GetHandler():SetHint(CHINT_RACE,rc)
end
function c99200179.value(e,c)
	return e:GetLabel()
end
function c99200179.drop(e,tp,eg,ep,ev,re,r,rp)
	if not re:GetHandler():IsType(TYPE_TRAP) then return end
	Duel.Hint(HINT_CARD,0,99200179)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c99200179.dfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0xda3790)
end
function c99200179.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c99200179.dfilter,1,nil,tp)
end
function c99200179.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end