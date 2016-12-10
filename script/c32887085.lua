--Illusion Art of the Saints
function c32887085.initial_effect(c)
	c:SetUniqueOnField(1,0,32887085)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_ATTACK+TIMING_END_PHASE)
	e1:SetCountLimit(1,32887085)
	e1:SetTarget(c32887085.acttg)
	c:RegisterEffect(e1)
	--atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c32887085.con)
	e2:SetTarget(c32887085.tg)
	e2:SetValue(800)
	c:RegisterEffect(e2)
	--atk up
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c32887085.con)
	e3:SetTarget(c32887085.tg)
	e3:SetValue(800)
	c:RegisterEffect(e3)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetCondition(c32887085.con)
	e4:SetTarget(c32887085.tg)
	e4:SetValue(c32887085.val)
	c:RegisterEffect(e4)
	--tograve
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_TOGRAVE)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(0,0x1e0)
	e5:SetCountLimit(1,32887085)
	e5:SetTarget(c32887085.tgtg)
	e5:SetOperation(c32887085.tgop)
	c:RegisterEffect(e5)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetRange(LOCATION_SZONE)
	e6:SetCode(EVENT_REMOVE)
	e6:SetCondition(c32887085.descon)
	e6:SetTarget(c32887085.destg)
	e6:SetOperation(c32887085.desop)
	c:RegisterEffect(e6)
end
function c32887085.acttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	if c32887085.tgcost(e,tp,eg,ep,ev,re,r,rp,0) and c32887085.tgtg(e,tp,eg,ep,ev,re,r,rp,0,chkc) and Duel.SelectYesNo(tp,94) then
		e:SetCategory(CATEGORY_TOGRAVE)
		e:SetOperation(c32887085.tgop)
		c32887085.tgcost(e,tp,eg,ep,ev,re,r,rp,1)
		c32887085.tgtg(e,tp,eg,ep,ev,re,r,rp,1,chkc)
		e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,65)
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end
function c32887085.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(32887085)==0 end
	e:GetHandler():RegisterFlagEffect(32887085,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c32887085.con(e)
	return Duel.GetTurnPlayer()~=e:GetHandlerPlayer()
end
function c32887085.tg(e,c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL
end
function c32887085.val(e,re,rp)
	return rp~=e:GetHandlerPlayer()
end
function c32887085.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1e20) and c:IsAbleToGrave()
end
function c32887085.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32887085.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c32887085.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c32887085.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c32887085.sdfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD) and c:IsLocation(LOCATION_REMOVED) and c:IsControler(tp)
end
function c32887085.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c32887085.sdfilter,1,nil,tp)
end
function c32887085.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsRelateToEffect(e) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,c,1,0,0)
end
function c32887085.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end
