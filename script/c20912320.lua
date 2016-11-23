--Action Field - The Sacred Sword's Pedestal
function c20912320.initial_effect(c)
	--Activate	
	local e1=Effect.CreateEffect(c)	
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetOperation(c20912320.op)
	c:RegisterEffect(e1)
	--redirect
	local e2=Effect.CreateEffect(c)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetOperation(c20912320.repop)
	c:RegisterEffect(e2)		
	--unaffectable
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e5:SetValue(1)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_IMMUNE_EFFECT)
	e6:SetValue(c20912320.ctcon2)
	c:RegisterEffect(e6)
	--cannot set
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetCode(EFFECT_CANNOT_SSET)
	e7:SetRange(LOCATION_SZONE)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e7:SetTargetRange(1,0)
	e7:SetTarget(c20912320.sfilter)
	c:RegisterEffect(e7)
	-- Add Action Card
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(20912320,0))
	e8:SetType(EFFECT_TYPE_QUICK_O)
	e8:SetRange(LOCATION_SZONE)
	e8:SetCode(EVENT_FREE_CHAIN)
	e8:SetCondition(c20912320.condition)
	e8:SetTarget(c20912320.Acttarget)
	e8:SetOperation(c20912320.operation)
	c:RegisterEffect(e8)
	--atk
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(20912320,1))
	e9:SetCategory(CATEGORY_ATKCHANGE)
	e9:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e9:SetRange(LOCATION_SZONE)
	e9:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e9:SetLabel(1)
	e9:SetCountLimit(1,20912320)
	e9:SetCondition(c20912320.effcon)
	e9:SetTarget(c20912320.target5)
	e9:SetOperation(c20912320.operation5)
	c:RegisterEffect(e9)
	--discard
	local e10=Effect.CreateEffect(c)
	e10:SetDescription(aux.Stringid(20912320,2))
	e10:SetCategory(CATEGORY_TOGRAVE)
	e10:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e10:SetRange(LOCATION_SZONE)
	e10:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e10:SetLabel(3)
	e10:SetCountLimit(1,20912320)
	e10:SetCondition(c20912320.effcon)
	e10:SetTarget(c20912320.target1)
	e10:SetOperation(c20912320.operation1)
	c:RegisterEffect(e10)
	--Special Summon
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(20912320,3))
	e11:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e11:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e11:SetRange(LOCATION_SZONE)
	e11:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e11:SetLabel(6)
	e11:SetCountLimit(1,20912320)
	e11:SetCondition(c20912320.effcon)
	e11:SetTarget(c20912320.target2)
	e11:SetOperation(c20912320.operation2)
	c:RegisterEffect(e11)
	--tohand
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(20912320,4))
	e12:SetCategory(CATEGORY_TOHAND)
	e12:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e12:SetRange(LOCATION_SZONE)
	e12:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e12:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e12:SetLabel(9)
	e12:SetCountLimit(1,20912320)
	e12:SetCondition(c20912320.effcon)
	e12:SetTarget(c20912320.target3)
	e12:SetOperation(c20912320.operation3)
	c:RegisterEffect(e12)
	-- draw
	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(20912320,5))
	e13:SetCategory(CATEGORY_DRAW)
	e13:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e13:SetRange(LOCATION_SZONE)
	e13:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e13:SetCountLimit(1,20912320)
	e13:SetCondition(c20912320.condition4)
	e13:SetTarget(c20912320.target4)
	e13:SetOperation(c20912320.operation4)
	c:RegisterEffect(e13)
	--search
	local e14=Effect.CreateEffect(c)
	e14:SetDescription(aux.Stringid(20912320,6))
	e14:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e14:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e14:SetRange(LOCATION_SZONE)
	e14:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e14:SetCountLimit(1,20912320)
	e14:SetCondition(c20912320.condition5)
	e14:SetTarget(c20912320.target6)
	e14:SetOperation(c20912320.operation6)
	c:RegisterEffect(e14)
	--stay
	local eb=Effect.CreateEffect(c)
	eb:SetType(EFFECT_TYPE_FIELD)
	eb:SetCode(EFFECT_CANNOT_TO_DECK)
	eb:SetRange(LOCATION_SZONE)
	eb:SetTargetRange(LOCATION_SZONE,0)
	eb:SetTarget(c20912320.tgn)
	c:RegisterEffect(eb)
	local ec=eb:Clone()
	ec:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(ec)
	local ed=eb:Clone()
	ed:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(ed)
	local ee=eb:Clone()
	ee:SetCode(EFFECT_CANNOT_REMOVE)
	c:RegisterEffect(ee)
end
function c20912320.ctcon2(e,re)
	return re:GetHandler()~=e:GetHandler()
end
--speed Duel Filter
function c20912320.SDfilter(c)
	return c:GetCode()==511004001
end
--vanilla mode filter
function c20912320.Vfilter(c)
	return c:GetCode()==511004002
end
function c20912320.op(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local tc2=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)	
	--check if number of card >20 if speed duel or >40 if other duel
	if Duel.IsExistingMatchingCard(c20912320.SDfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_REMOVED,0,1,nil) and Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_DECK,0,nil):GetCount()<20 then
	Duel.Win(1-tp,0x55)
	end
	if Duel.GetMatchingGroup(nil,tp,LOCATION_HAND+LOCATION_DECK,0,e:GetHandler()):GetCount()<40 and not Duel.IsExistingMatchingCard(c20912320.SDfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_REMOVED,0,1,nil) then
	Duel.Win(1-tp,0x55)
	end
	--move to field
	if tc==nil then
		Duel.MoveToField(e:GetHandler(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		if tc2==nil then
			local token=Duel.CreateToken(tp,20912320,nil,nil,nil,nil,nil,nil)		
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			e1:SetValue(TYPE_SPELL+TYPE_FIELD)
			token:RegisterEffect(e1)
			Duel.MoveToField(token,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.SpecialSummonComplete()
		end
		-- add ability Yell when Vanilla mode activated
		-- if Duel.IsExistingMatchingCard(c20912320.Vfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_REMOVED,0,1,nil) then
			-- c20912320.tableAction.push(95000200)
		-- end
	else
		Duel.SendtoDeck(e:GetHandler(),nil,-2,REASON_EFFECT)
	end
	if e:GetHandler():GetPreviousLocation()==LOCATION_HAND then
		Duel.Draw(tp,1,REASON_RULE)
	end
end
function c20912320.sfilter(e,c,tp)
	return c:IsType(TYPE_FIELD) 
end
function c20912320.tgn(e,c)
	return c==e:GetHandler()
end
-- Add Action Card
function c20912320.Acttarget(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return true end
Duel.Hint(HINT_SELECTMSG,tp,564)
if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then
local g=Duel.GetDecktopGroup(tp,1)
local tc=g:GetFirst()
math.randomseed( tc:getcode() )
end
i = math.random(20)
ac=math.random(1,tableAction_size)
e:SetLabel(tableAction[ac])
end
function c20912320.operation(e,tp,eg,ep,ev,re,r,rp)
local dc=Duel.TossDice(tp,1)
if dc==2 or dc==3 or dc==4 or dc==6 then
Duel.RegisterFlagEffect(tp,20912320,RESET_PHASE+PHASE_END,0,1)
end
if dc==1 or dc==2 then
	--- check action Trap
	if (e:GetLabel()==20912325 or e:GetLabel()==20912326) then
	local token=Duel.CreateToken(tp,e:GetLabel(),nil,nil,nil,nil,nil,nil)		
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_TRAP)
		token:RegisterEffect(e1)
		Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.SpecialSummonComplete()
	if not Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) then
			Duel.SendtoGrave(token,nil,REASON_RULE) end
		local tc=token
		Duel.ConfirmCards(tp,tc)
		if tc:IsType(TYPE_TRAP) then
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
		if not te then
			Duel.Destroy(tc,REASON_EFFECT)
		else
			local condition=te:GetCondition()
			local cost=te:GetCost()
			local target=te:GetTarget()
			local operation=te:GetOperation()
			if te:GetCode()==EVENT_FREE_CHAIN and not tc:IsStatus(STATUS_SET_TURN)
				and (not condition or condition(te,tep,eg,ep,ev,re,r,rp))
				and (not cost or cost(te,tep,eg,ep,ev,re,r,rp,0))
				and (not target or target(te,tep,eg,ep,ev,re,r,rp,0)) then
				Duel.ClearTargetCard()
				e:SetProperty(te:GetProperty())
				Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
				Duel.ChangePosition(tc,POS_FACEUP)
				if tc:GetType()==TYPE_TRAP then
					tc:CancelToGrave(false)
				end
				tc:CreateEffectRelation(te)
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
				if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				if g then
					local tg=g:GetFirst() 
					while tg do
					tg:CreateEffectRelation(te)
					tg=g:GetNext()
					end
				end
				Duel.BreakEffect()
				if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
				tc:ReleaseEffectRelation(te)
				if tg then
					tg=g:GetFirst() 
					while tg do
					tg:ReleaseEffectRelation(te)
					tg=g:GetNext()
					end
				end
			else
				Duel.Destroy(tc,REASON_EFFECT)
			end
		end
	end
else
	---Action Spell
		local token=Duel.CreateToken(tp,e:GetLabel(),nil,nil,nil,nil,nil,nil)		
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_QUICKPLAY)
		token:RegisterEffect(e1)
		Duel.SendtoHand(token,nil,REASON_EFFECT)
		Duel.SpecialSummonComplete()	
	end
end
	if dc==5 or dc==6 then
	--- check action Trap
	if (e:GetLabel()==20912325 or e:GetLabel()==20912326) then
	local token=Duel.CreateToken(1-tp,e:GetLabel(),nil,nil,nil,nil,nil,nil)		
		Duel.SpecialSummonStep(token,0,1-tp,1-tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_TRAP)
		token:RegisterEffect(e1)
		Duel.MoveToField(token,1-tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.SpecialSummonComplete()
	if not Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) then
			Duel.SendtoGrave(token,nil,REASON_RULE) end
		local tc=token
		Duel.ConfirmCards(tp,tc)
		if tc:IsType(TYPE_TRAP) then
			local te=tc:GetActivateEffect()
			local tep=tc:GetControler()
		if not te then
			Duel.Destroy(tc,REASON_EFFECT)
		else
			local condition=te:GetCondition()
			local cost=te:GetCost()
			local target=te:GetTarget()
			local operation=te:GetOperation()
			if te:GetCode()==EVENT_FREE_CHAIN and not tc:IsStatus(STATUS_SET_TURN)
				and (not condition or condition(te,tep,eg,ep,ev,re,r,rp))
				and (not cost or cost(te,tep,eg,ep,ev,re,r,rp,0))
				and (not target or target(te,tep,eg,ep,ev,re,r,rp,0)) then
				Duel.ClearTargetCard()
				e:SetProperty(te:GetProperty())
				Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
				Duel.ChangePosition(tc,POS_FACEUP)
				if tc:GetType()==TYPE_TRAP then
					tc:CancelToGrave(false)
				end
				tc:CreateEffectRelation(te)
				if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
				if target then target(te,tep,eg,ep,ev,re,r,rp,1) end
				local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
				if g then
					local tg=g:GetFirst() 
					while tg do
					tg:CreateEffectRelation(te)
					tg=g:GetNext()
					end
				end
				Duel.BreakEffect()
				if operation then operation(te,tep,eg,ep,ev,re,r,rp) end
				tc:ReleaseEffectRelation(te)
				if tg then
					tg=g:GetFirst() 
					while tg do
					tg:ReleaseEffectRelation(te)
					tg=g:GetNext()
					end
				end
			else
				Duel.Destroy(tc,REASON_EFFECT)
			end
		end
	end
else
	---Action Spell
		local token=Duel.CreateToken(1-tp,e:GetLabel(),nil,nil,nil,nil,nil,nil)		
		Duel.SpecialSummonStep(token,0,1-tp,1-tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		e1:SetValue(TYPE_SPELL+TYPE_QUICKPLAY)
		token:RegisterEffect(e1)
		Duel.SendtoHand(token,1-tp,REASON_EFFECT)
		Duel.SpecialSummonComplete()
		end	
	end
end
function c20912320.condition(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c20912320.cfilter,tp,LOCATION_SZONE+LOCATION_HAND,0,1,nil)
	and Duel.GetFlagEffect(e:GetHandlerPlayer(),20912320)==0
	and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function c20912320.cfilter(c)
	return c:IsSetCard(0xac1)
end
tableAction = {
20912321,
20912322,
20912323,
20912324,
20912325,
20912326
} 
tableAction_size=6
function c20912320.repop(e)
	local c=e:GetHandler()
		if c:GetFlagEffect(900000007)==0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_END)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetLabelObject(c)
		e1:SetOperation(c20912320.returnop)
		Duel.RegisterEffect(e1,0)
		c:RegisterFlagEffect(900000007,0,0,1)
	end
	Duel.SendtoDeck(c,nil,-2,REASON_RULE)
end
function c20912320.returnop(e)
	local c=e:GetLabelObject()
	local tp=c:GetControler()
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if not fc then
		Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
	if fc and fc:GetFlagEffect(120912320)==0 then
	--action card get
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(20912320,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c20912320.condition)
	e1:SetTarget(c20912320.Acttarget)
	e1:SetOperation(c20912320.operation)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	fc:RegisterEffect(e1)
	--cannot set
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SSET)
	e4:SetRange(LOCATION_SZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetTargetRange(1,0)
	e4:SetReset(RESET_EVENT+0x1fe0000)
	e4:SetTarget(c20912320.sfilter)
	fc:RegisterEffect(e4)
	fc:RegisterFlagEffect(120912320,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c20912320.confilter(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a2) and c:IsType(TYPE_MONSTER)
end
function c20912320.effcon(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return false end
	local g=Duel.GetMatchingGroup(c20912320.confilter,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)>=e:GetLabel()
end
function c20912320.filter1(c)
	return c:IsSetCard(0xd0a2) and c:IsAbleToGrave()
end
function c20912320.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20912320.filter1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,0,1,tp,LOCATION_DECK)
end
function c20912320.operation1(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c20912320.filter1,tp,LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_EFFECT)
end
function c20912320.filter2(c,e,tp)
	return  c:IsSetCard(0xd0a2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c20912320.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c20912320.filter2,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c20912320.eqfilter(c,tc,tp)
	return c:IsType(TYPE_EQUIP) and c:IsSetCard(0xd0a2) and c:CheckEquipTarget(tc) and c:CheckUniqueOnField(tp)
end
function c20912320.operation2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c20912320.filter2,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)==0 then return end
	local tg=Duel.GetMatchingGroup(c20912320.eqfilter,tp,LOCATION_HAND,0,nil,tc,tp)
	if tg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(20912320,7)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
		local sg=tg:Select(tp,1,1,nil)
		Duel.Equip(tp,sg:GetFirst(),tc,true)
	end
end
function c20912320.thfilter(c)
	return c:IsSetCard(0xd0a2) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c20912320.target3(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c20912320.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20912320.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c20912320.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c20912320.operation3(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
function c20912320.condition4(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return false end
	local g=Duel.GetMatchingGroup(c20912320.confilter,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)==12
end
function c20912320.target4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c20912320.operation4(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Draw(tp,1,REASON_EFFECT)
end
function c20912320.filter5(c)
	return c:IsFaceup() and c:IsSetCard(0xd0a2) and c:IsType(TYPE_MONSTER)
end
function c20912320.target5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20912320.filter5,tp,LOCATION_MZONE,0,1,nil) end
end
function c20912320.operation5(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c20912320.filter5,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(300)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function c20912320.condition5(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return false end
	local g=Duel.GetMatchingGroup(c20912320.confilter,tp,LOCATION_GRAVE,0,nil)
	return g:GetClassCount(Card.GetCode)==15
end
function c20912320.thfilter2(c)
	return c:IsSetCard(0xd0a2) and c:IsType(TYPE_EQUIP) and c:IsAbleToHand()
end
function c20912320.target6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20912320.thfilter2,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c20912320.operation6(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c20912320.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
