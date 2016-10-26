--Necromantic Rite
function c77777750.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--counter
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetDescription(aux.Stringid(77777750,0))
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c77777750.ctcon)
	e2:SetOperation(c77777750.ctop)
	c:RegisterEffect(e2)
	--ToHand/SS
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(77777750,1))
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c77777750.target)
	e4:SetOperation(c77777750.operation)
	c:RegisterEffect(e4)
end

function c77777750.gfilter(c,tp)
	return c:GetType()==0x81
end
function c77777750.ctcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c77777750.gfilter,1,nil,tp)and not re:GetHandler():IsCode(77777750)
end
function c77777750.ctop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():AddCounter(0x1666+COUNTER_NEED_ENABLE,1)
end


function c77777750.filter1(c)
	return c:IsSetCard(0x1c8) and c:IsAbleToHand()and c:IsType(TYPE_RITUAL)
end
function c77777750.filter2(c)
	return c:IsType(TYPE_RITUAL) and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x1c8)-- and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c77777750.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=e:GetHandler():IsCanRemoveCounter(tp,0x1666,2,REASON_COST)
		and Duel.IsExistingMatchingCard(c77777750.filter1,tp,LOCATION_GRAVE,0,1,nil)
	local b2=e:GetHandler():IsCanRemoveCounter(tp,0x1666,6,REASON_COST)
		and Duel.IsExistingMatchingCard(c77777750.filter2,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	local op=0
	if b1 and b2 then
		op=Duel.SelectOption(tp,aux.Stringid(77777750,2),aux.Stringid(77777750,3))
	elseif b1 then
		op=Duel.SelectOption(tp,aux.Stringid(77777750,2))
	else
		op=Duel.SelectOption(tp,aux.Stringid(77777750,3))+1
	end
	e:SetLabel(op)
	if op==0 then
		e:SetCategory(CATEGORY_TOHAND)
		e:GetHandler():RemoveCounter(tp,0x1666,2,REASON_COST)
		local g=Duel.SelectTarget(tp,c77777750.filter1,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e:GetHandler():RemoveCounter(tp,0x1666,6,REASON_COST)
		local g=Duel.GetMatchingGroup(c77777750.filter2,tp,LOCATION_GRAVE,0,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	end
end
function c77777750.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		end
	else
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c77777750.filter2,tp,LOCATION_GRAVE,0,ft,ft,nil,e,tp)
		if g:GetCount()>0 then
			local fid=e:GetHandler():GetFieldID()
			local tc=g:GetFirst()
			while tc do
				Duel.SpecialSummon(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
			--attack twice
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetDescription(aux.Stringid(77777750,4))
			e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EXTRA_ATTACK)
			e1:SetValue(1)
			tc:RegisterEffect(e1,tp)
			--actlimit
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetDescription(aux.Stringid(77777750,5))
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CLIENT_HINT)
			e2:SetCode(EFFECT_CANNOT_ACTIVATE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetTargetRange(0,1)
			e2:SetValue(c77777750.aclimit)
			e2:SetCondition(c77777750.actcon)
			tc:RegisterEffect(e2,tp)
			tc:RegisterFlagEffect(77777750,RESET_EVENT+0x1fe0000,0,1)
			tc=g:GetNext()
			end
		end
	end
end

function c77777750.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c77777750.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end
