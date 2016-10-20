--Lord's Blade Ciaran
--lua script by SGJin
function c12310728.initial_effect(c)
	--Only 1 face up Lord's Blade Ciaran
	c:SetUniqueOnField(1,0,12310728)
	-- Special Summon (when Artorias is dead)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c12310728.spscon)
	c:RegisterEffect(e1)
	-- Banish face-down card (Master Assassin)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(12310728,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c12310728.bsptg)
	e2:SetOperation(c12310728.bspop)
	c:RegisterEffect(e2)
	-- Banish until the end of the turn (Ninja vanish)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12310728,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetCountLimit(1)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCost(c12310728.rmcost)
	e3:SetTarget(c12310728.rmtg)
	e3:SetOperation(c12310728.rmop)
	c:RegisterEffect(e3)
end
function c12310728.spscon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(Card.IsCode,c:GetControler(),LOCATION_GRAVE,0,1,nil,12310718)
end
function c12310728.filter(c)
	return c:IsFacedown() and c:IsAbleToRemove()
end
function c12310728.bsptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and c12310728.filter(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c12310728.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,g:GetCount(),0,0)
end
function c12310728.bspop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsFacedown() and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c12310728.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_DARK+ATTRIBUTE_LIGHT) and c:IsAbleToRemoveAsCost()
end
function c12310728.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c12310728.cfilter,tp,LOCATION_GRAVE,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c12310728.cfilter,tp,LOCATION_GRAVE,0,2,2,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c12310728.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,e:GetHandler(),1,0,0)
end
function c12310728.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) and
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT) then 
		c:RegisterFlagEffect(12310728,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(12310728,1))
		e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetRange(LOCATION_REMOVED)
		e1:SetCountLimit(1)
		e1:SetCondition(c12310728.spcon)
		e1:SetTarget(c12310728.sptg)
		e1:SetOperation(c12310728.spop)
		c:RegisterEffect(e1)
	end
end
function c12310728.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(12310728)~=0
end
function c12310728.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c12310728.spop(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
