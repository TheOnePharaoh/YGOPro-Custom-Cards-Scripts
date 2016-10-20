--Knight Artorias - The Abysswalker
--lua script by SGJin
function c12310718.initial_effect(c)
	c:EnableReviveLimit()
	-- Special Summon by losing Humanity
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12310718,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c12310718.spcon)
	e1:SetOperation(c12310718.spop)
	c:RegisterEffect(e1)
	-- Banish to the Abyss
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(12310718,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(c12310718.rmcost)
	e3:SetTarget(c12310718.rmtg)
	e3:SetOperation(c12310718.rmop)
	c:RegisterEffect(e3)
	-- Berserk Attack
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(12310718,0))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e4:SetCondition(c12310718.atcon)
	e4:SetOperation(c12310718.atop)
	c:RegisterEffect(e4)
end
function c12310718.spfilter(c)
	return c:IsCode(12310712) and c:IsAbleToRemoveAsCost()
end
function c12310718.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c12310718.spfilter,tp,LOCATION_GRAVE,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and (g:GetCount()>1 or g:IsExists(Card.IsHasEffect,1,nil,12310713))
end
function c12310718.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c12310718.spfilter,tp,LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sgc1=g:Select(tp,1,1,nil):GetFirst()
	g:RemoveCard(sgc1)
	if g:GetCount()>0 and (not sgc1:IsHasEffect(12310713) or not Duel.SelectYesNo(tp,aux.Stringid(61965407,0))) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sgc2=g:Select(tp,1,1,nil):GetFirst()
		sgc1=Group.FromCards(sgc1,sgc2)
	end
	Duel.Remove(sgc1,POS_FACEUP,REASON_COST)
end
function c12310718.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetAttackAnnouncedCount()==0 and Duel.CheckLPCost(tp,1000) end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1,true)
	c:RegisterFlagEffect(12310718,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	Duel.PayLPCost(tp,1000)
end
function c12310718.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:IsAbleToRemove() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c12310718.rmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function c12310718.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and c:GetFlagEffect(12310718)==0 and Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c12310718.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
		e1:SetValue(c:GetBaseAttack()*2)
		c:RegisterEffect(e1)
	end
end